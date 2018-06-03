//
//  DisplayCommunication.m
//  ObjectiveC SDK
//
//  Created by Yuji on 2016/**/**.
//  Copyright © 2016年 Star Micronics. All rights reserved.
//

#import "DisplayCommunication.h"

@interface RequestDisplayStatusFunction : IStarIoExtFunction

@property (nonatomic, readonly) BOOL connect;

- (NSData *)createCommands;

@end

@implementation RequestDisplayStatusFunction

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
                    *(work + 3) == 0x41) {
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
    
    unsigned char data[] = {0x1b, 0x1e, 'B', 0x41};
    
    [commands appendBytes:data length:sizeof(data)];
    
    return commands;
}

@end

@implementation DisplayCommunication

+ (BOOL)requestStatus:(SMPort *)port completionHandler:(RequestStatusCompletionHandler)completionHandler {
    RequestDisplayStatusFunction *function = [[RequestDisplayStatusFunction alloc] init];
    
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
    
    unsigned char header[] = {0x1b, 0x1d, 'B', 0x40, l0, l1};
    
    [data appendBytes:header length:sizeof(header)];
    
    [data appendData:commands];
    
    return [super sendCommandsDoNotCheckCondition:data port:port completionHandler:completionHandler];
}

@end
