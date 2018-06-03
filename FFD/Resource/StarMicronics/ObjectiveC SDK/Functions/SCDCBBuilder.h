//
//  SCDCBBuilder.h
//  ObjectiveC SDK
//
//  Created by Yuji on 2016/**/**.
//  Copyright © 2016年 Star Micronics. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - International

typedef NS_ENUM(NSInteger, SCDCBInternationalType) {
    SCDCBInternationalTypeUSA          = 0x00,
    SCDCBInternationalTypeFrance       = 0x01,
    SCDCBInternationalTypeGermany      = 0x02,
    SCDCBInternationalTypeUK           = 0x03,
    SCDCBInternationalTypeDenmark      = 0x04,
    SCDCBInternationalTypeSweden       = 0x05,
    SCDCBInternationalTypeItaly        = 0x06,
    SCDCBInternationalTypeSpain        = 0x07,
    SCDCBInternationalTypeJapan        = 0x08,
    SCDCBInternationalTypeNorway       = 0x09,
    SCDCBInternationalTypeDenmark2     = 0x0a,
    SCDCBInternationalTypeSpain2       = 0x0b,
    SCDCBInternationalTypeLatinAmerica = 0x0c,
    SCDCBInternationalTypeKorea        = 0x0d
};

#pragma mark - CodePage

typedef NS_ENUM(NSInteger, SCDCBCodePageType) {
    SCDCBCodePageTypeCP437              = 0x00,
    SCDCBCodePageTypeKatakana           = 0x01,
    SCDCBCodePageTypeCP850              = 0x02,
    SCDCBCodePageTypeCP860              = 0x03,
    SCDCBCodePageTypeCP863              = 0x04,
    SCDCBCodePageTypeCP865              = 0x05,
    SCDCBCodePageTypeCP1252             = 0x06,
    SCDCBCodePageTypeCP866              = 0x07,
    SCDCBCodePageTypeCP852              = 0x08,
    SCDCBCodePageTypeCP858              = 0x09,
    SCDCBCodePageTypeJapanese           = 0x0a,
    SCDCBCodePageTypeSimplifiedChinese  = 0x0b,
    SCDCBCodePageTypeTraditionalChinese = 0x0c,
    SCDCBCodePageTypeHangul             = 0x0d
};

#pragma mark - Cursor

typedef NS_ENUM(NSInteger, SCDCBCursorMode) {
    SCDCBCursorModeOff   = 0x00,
    SCDCBCursorModeBlink = 0x01,
    SCDCBCursorModeOn    = 0x02
};

#pragma mark - Contrast

typedef NS_ENUM(NSInteger, SCDCBContrastMode) {
    SCDCBContrastModeMinus3  = 0x00,
    SCDCBContrastModeMinus2  = 0x01,
    SCDCBContrastModeMinus1  = 0x02,
    SCDCBContrastModeDefault = 0x03,
    SCDCBContrastModePlus1   = 0x04,
    SCDCBContrastModePlus2   = 0x05,
    SCDCBContrastModePlus3   = 0x06
};

#pragma mark - Member

@interface SCDCBBuilder : NSObject

@property (nonatomic, readonly) NSMutableData *commands;

+ (SCDCBBuilder *)createCommandBuilder;

- (void)appendByte:(unsigned char)data;

- (void)appendData:(NSData *)otherData;

- (void)appendBytes:(const void *)bytes length:(NSUInteger)length;

- (void)appendBackSpace;

- (void)appendHorizontalTab;

- (void)appendLineFeed;

- (void)appendCarriageReturn;

- (void)appendGraphic:(unsigned char *)image;

- (void)appendCharacterSet:(SCDCBInternationalType)internationalType codePageType:(SCDCBCodePageType)codePageType;

- (void)appendDeleteToEndOfLine;

- (void)appendClearScreen;

- (void)appendHomePosition;

- (void)appendTurnOn:(BOOL)turnOn;

- (void)appendSpecifiedPosition:(int)x y:(int)y;

- (void)appendCursorMode:(SCDCBCursorMode)cursorMode;

- (void)appendContrastMode:(SCDCBContrastMode)contrastMode;

- (void)appendUserDefinedCharacter:(int)index code:(int)code font:(unsigned char *)font;

- (void)appendUserDefinedDbcsCharacter:(int)index code:(int)code font:(unsigned char *)font;

@end
