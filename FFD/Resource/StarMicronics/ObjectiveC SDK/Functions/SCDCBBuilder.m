//
//  SCDCBBuilder.m
//  ObjectiveC SDK
//
//  Created by Yuji on 2016/**/**.
//  Copyright © 2016年 Star Micronics. All rights reserved.
//

#import "SCDCBBuilder.h"

@implementation SCDCBBuilder

+ (SCDCBBuilder *)createCommandBuilder {
    return [[SCDCBBuilder alloc] init];
}

- (id)init {
    self = [super init];
    
    if (self == nil) {
        return nil;
    }
    
    _commands = [[NSMutableData alloc] init];
    
    return self;
}

- (void)appendByte:(unsigned char)data {
    [_commands appendBytes:(unsigned char []) {data} length:sizeof((unsigned char []) {data})];
}

- (void)appendData:(NSData *)otherData {
    [_commands appendData:otherData];
}

- (void)appendBytes:(const void *)bytes length:(NSUInteger)length {
    [_commands appendData:[NSData dataWithBytes:bytes length:length]];
}

- (void)appendBackSpace {
    unsigned char data[] = {0x08};
    
    [_commands appendBytes:data length:sizeof(data)];
}

- (void)appendHorizontalTab {
    unsigned char data[] = {0x09};
    
    [_commands appendBytes:data length:sizeof(data)];
}

- (void)appendLineFeed {
    unsigned char data[] = {0x0a};
    
    [_commands appendBytes:data length:sizeof(data)];
}

- (void)appendCarriageReturn {
    unsigned char data[] = {0x0d};
    
    [_commands appendBytes:data length:sizeof(data)];
}

- (void)appendGraphic:(unsigned char *)image {
    unsigned char data[] = {0x1b, 0x20};
    
    [_commands appendBytes:data length:sizeof(data)];
    
    [_commands appendBytes:image length:5 * 160];
}

- (void)appendCharacterSet:(SCDCBInternationalType)internationalType codePageType:(SCDCBCodePageType)codePageType {
    unsigned char data[] = {
        0x1b, 0x52, internationalType,
        0x1b, 0x52, codePageType + 0x30
    };
    
    [_commands appendBytes:data length:sizeof(data)];
}

- (void)appendDeleteToEndOfLine {
    unsigned char data[] = {0x1b, 0x5b, 0x30, 0x4b};
    
    [_commands appendBytes:data length:sizeof(data)];
}

- (void)appendClearScreen {
    unsigned char data[] = {0x1b, 0x5b, 0x32, 0x4a};
    
    [_commands appendBytes:data length:sizeof(data)];
}

- (void)appendHomePosition {
    unsigned char data[] = {0x1b, 0x5b, 0x48, 0x27};
    
    [_commands appendBytes:data length:sizeof(data)];
}

- (void)appendTurnOn:(BOOL)turnOn {
    unsigned char turnOnOff;
    
    if (turnOn) {
        turnOnOff = 0x01;
    }
    else {
        turnOnOff = 0x00;
    }
    
    unsigned char data[] = {0x1b, 0x5b, turnOnOff, 0x50};
    
    [_commands appendBytes:data length:sizeof(data)];
}

- (void)appendSpecifiedPosition:(int)x y:(int)y {
    if (! (x >= 1 && x <= 20)) {
        x = 1;
    }
    
    if (! (y >= 1 && y <= 2)) {
        y = 1;
    }
    
    unsigned char data[] = {0x1b, 0x5b, y, 0x3b, x, 0x48};
    
    [_commands appendBytes:data length:sizeof(data)];
}

- (void)appendCursorMode:(SCDCBCursorMode)cursorMode {
    unsigned char cursor;
    
    switch (cursorMode) {
        default                   : cursor = 0x00; break;     // SCDCBCursorModeOff
        case SCDCBCursorModeBlink : cursor = 0x01; break;
        case SCDCBCursorModeOn    : cursor = 0x02; break;
    }
    
    unsigned char data[] = {0x1b, 0x5c, 0x3f, 0x4c, 0x43, cursor};
    
    [_commands appendBytes:data length:sizeof(data)];
}

- (void)appendContrastMode:(SCDCBContrastMode)contrastMode {
    unsigned char data[] = {0x1b, 0x5c, 0x3f, 0x4c, 0x44, contrastMode, 0x03};
    
    [_commands appendBytes:data length:sizeof(data)];
}

- (void)appendUserDefinedCharacter:(int)index code:(int)code font:(unsigned char *)font {
    unsigned char data[] = {0x1b, 0x5c, 0x3f, 0x4c, 0x57, 0x01, 0x3b, index, 0x3b, code, 0x3b};
    
    [_commands appendBytes:data length:sizeof(data)];
    
    if (code != 0x00) {
        [_commands appendBytes:font length:16];
    }
}

- (void)appendUserDefinedDbcsCharacter:(int)index code:(int)code font:(unsigned char *)font {
    unsigned char data[] = {0x1b, 0x5c, 0x3f, 0x4c, 0x57, 0x02, 0x3b, index, 0x3b, code / 0x0100, code % 0x0100, 0x3b};
    
    [_commands appendBytes:data length:sizeof(data)];
    
    if (code != 0x00) {
        [_commands appendBytes:font length:32];
    }
}

@end
