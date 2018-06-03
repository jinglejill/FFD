//
//  DisplayFunctions.h
//  ObjectiveC SDK
//
//  Created by Yuji on 2016/**/**.
//  Copyright © 2016年 Star Micronics. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SCDCBBuilder.h"

@interface DisplayFunctions : NSObject

+ (NSData *)createClearScreen;

+ (NSData *)createTextPattern:(int)number;

+ (NSData *)createGraphicPattern:(int)number;

+ (NSData *)createCharacterSet:(SCDCBInternationalType)internationalType codePageType:(SCDCBCodePageType)codePageType;

+ (NSData *)createTurnOn:(BOOL)turnOn;

+ (NSData *)createCursorMode:(SCDCBCursorMode)cursorMode;

+ (NSData *)createContrastMode:(SCDCBContrastMode)contrastMode;

+ (NSData *)createUserDefinedCharacter:(BOOL)set;

@end
