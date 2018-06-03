//
//  ScaleCommunication.m
//  ObjectiveC SDK
//
//  Created by Yuji on 2016/**/**.
//  Copyright © 2016年 Star Micronics. All rights reserved.
//

#import "ScaleCommunication.h"

@interface RequestScaleStatusFunction : IStarIoExtFunction

@property (nonatomic, readonly) BOOL connect;

- (NSData *)createCommands;

@end

@implementation RequestScaleStatusFunction

- (id)init {
    self = [super init];
    
    if (!self){
        return nil;
    }
    
    StarIoExtFunctionCompletionHandler handler = ^(uint8_t *buffer, int *length) {
        uint8_t *work = buffer;
        
        if (*length >= 5) {
            while (*length >= 5) {
                if (* work      == 0x1b &&
                    *(work + 1) == 0x1e &&
                    *(work + 2) == 'B'  &&
                    *(work + 3) == 0x51) {
                    *length -= 5 - 1;
                    
                    memmove(buffer, work + 5 - 1, *length);
                    
                    if ((buffer[0] & 0x02) != 0x00) {
                        _connect = YES;
                    }
                    else {
                        _connect = NO;
                    }
                    
                    return YES;
                }
                
                work++;
                
                *length -= 1;
            }
            
            memmove(buffer, work, 5 - 1);
        }
        
        return NO;
    };
    
    self.completionHandler = handler;
    
    _connect = NO;
    
    return self;
}

- (NSData *)createCommands {
    NSMutableData *commands = [[NSMutableData alloc] init];
    
    unsigned char data[] = {0x1b, 0x1e, 'B', 0x51};
    
    [commands appendBytes:data length:sizeof(data)];
    
    return commands;
}

@end

@implementation ScaleCommunication

+ (BOOL)requestStatus:(SMPort *)port completionHandler:(RequestStatusCompletionHandler)completionHandler {
    RequestScaleStatusFunction *function = [[RequestScaleStatusFunction alloc] init];
    
    return [super sendFunctionDoNotCheckCondition:function port:port completionHandler:^(BOOL result, NSString *title, NSString *message) {
        if (completionHandler != nil) {
            completionHandler(result, title, message, function.connect);
        }
    }];
}

+ (BOOL)passThroughCommands:(NSData *)commands port:(SMPort *)port completionHandler:(SendCompletionHandler)completionHandler {
    NSMutableData *data = [[NSMutableData alloc] init];
    
    unsigned char l0 = (unsigned char) (commands.length % 0x0100);
    unsigned char l1 = (unsigned char) (commands.length / 0x0100);
    
    unsigned char header[] = {0x1b, 0x1d, 'B', 0x50, l0, l1};
    
    [data appendBytes:header length:sizeof(header)];
    
    [data appendData:commands];
    
    return [super sendCommandsDoNotCheckCondition:data port:port completionHandler:completionHandler];
}

+ (BOOL)passThroughFunction:(IStarIoExtFunction *)function port:(SMPort *)port completionHandler:(SendCompletionHandler)completionHandler {
    BOOL result = NO;
    
    NSString *title   = @"";
    NSString *message = @"";
    
    NSMutableData *data = [[NSMutableData alloc] init];
    
    unsigned char clearBuffer[] = {0x1b, 0x1d, 'B', 0x53};
    
    [data appendBytes:clearBuffer length:sizeof(clearBuffer)];
    
    NSData *command = [function createCommands];
    
    unsigned char l0 = (unsigned char) (command.length % 0x0100);
    unsigned char l1 = (unsigned char) (command.length / 0x0100);
    
    unsigned char header[] = {0x1b, 0x1d, 'B', 0x50, l0, l1};
    
    for (int i = 0; i < 3; i++) {     // Because the scale doesn't sometimes react.
        [data appendBytes:header length:sizeof(header)];
        
        [data appendData:command];
    }
    
    @try {
        while (YES) {
            if (port == nil) {
                title = @"Fail to Open Port";
                break;
            }
            
            StarPrinterStatus_2 printerStatus;
            
            [port getParsedStatus:&printerStatus :2];
            
//          if (printerStatus.offline == SM_TRUE) {     // Do not check condition.
//              title   = @"Printer Error";
//              message = @"Printer is offline (GetParsedStatus)";
//              break;
//          }
            
            NSDate *startDate = [NSDate date];
            
            int total = 0;
            
            while (total < data.length) {
                uint32_t writeLength = [port writePort:data.bytes :total :(uint32_t) (data.length - total)];
                
                total += writeLength;
                
                if ([[NSDate date] timeIntervalSinceDate:startDate] >= 30.0) {     // 30000mS!!!
                    break;
                }
            }
            
            if (total < data.length) {
                title   = @"Printer Error";
                message = @"Write port timed out";
                break;
            }
            
            [NSThread sleepForTimeInterval:0.1];     // Break time.
            
            startDate = [NSDate date];     // Restart
            
            while (result == NO) {
                if ([[NSDate date] timeIntervalSinceDate:startDate] >= 1.0) {     // 1000mS!!!
                    title   = @"Printer Error";
                    message = @"Read port timed out";
                    break;
                }
                
                unsigned char requestData[] = {0x1b, 0x1d, 'B', 0x52};
                
                total = 0;
                
                while (total < sizeof(requestData)) {
                    uint32_t writeLength = [port writePort:requestData :total :sizeof(requestData) - total];
                    
                    total += writeLength;
                    
                    if ([[NSDate date] timeIntervalSinceDate:startDate] >= 1.0) {     // 1000mS!!!
                        break;
                    }
                }
                
                if (total < sizeof(requestData)) {
                    title   = @"Printer Error";
                    message = @"Write port timed out";
                    break;
                }
                
                uint8_t buffer[1024 + 8];
                
                int length;
                
                total = 0;
                
                while (result == NO) {
                    [NSThread sleepForTimeInterval:0.1];     // Break time.
                    
                    if ([[NSDate date] timeIntervalSinceDate:startDate] >= 1.0) {     // 1000mS!!!
                        title   = @"Printer Error";
                        message = @"Read port timed out";
                        break;
                    }
                    
                    int readLength = [port readPort:buffer :total :1024 - total];
                    
//                  NSLog(@"readPort:%d", readLength);
//
//                  for (int i = 0; i < readLength; i++) {
//                      NSLog(@"%02x", buffer[total + i]);
//                  }
                    
                    total += readLength;
                    
                    if (total >= 6) {
                        for (int i = 0; i <= total - 6; i++) {
                            if (buffer[i + 0] == 0x1b &&
                                buffer[i + 1] == 0x1d &&
                                buffer[i + 2] == 'B'  &&
                                buffer[i + 3] == 0x52) {
                                length = buffer[i + 4] + buffer[i + 5] * 0x0100;
                                
                                memmove(buffer, &buffer[i + 6], total - (i + 6));
                                
                                total -= i + 6;
                                
                                result = YES;
                                break;
                            }
                        }
                        
                        if (result == NO) {
                            memmove(buffer, &buffer[total - (6 - 1)], 6 - 1);
                            
                            total = 6 - 1;
                        }
                    }
                }
                
                if (result == YES) {
                    result = NO;
                    
                    if (length <= 1024) {     // Not overflow.
                        while (total < length) {
                            if ([[NSDate date] timeIntervalSinceDate:startDate] >= 1.0) {     // 1000mS!!!
                                title   = @"Printer Error";
                                message = @"Read port timed out";
                                break;
                            }
                            
                            @try {
                                int readLength = [port readPort:buffer :total :1024 - total];
                                
//                              NSLog(@"readPort:%d", readLength);
//
//                              for (int i = 0; i < readLength; i++) {
//                                  NSLog(@"%02x", buffer[total + i]);
//                              }
                                
                                total += readLength;
                            }
                            @catch (NSException *exc) {
                                title   = @"Printer Error";
                                message = @"Read port timed out";
                                break;
                            }
                        }
                        
                        if (function.completionHandler(buffer, &total) == YES) {
                            title   = @"Send Commands";
                            message = @"Success";
                            
                            result = YES;
                        }
                    }
                }
            }
            
            break;
        }
    }
    @catch (PortException *exc) {
        title   = @"Printer Error";
        message = @"Write port timed out (PortException)";
    }
    
    if (completionHandler != nil) {
        completionHandler(result, title, message);
    }
    
    return result;
}

@end
