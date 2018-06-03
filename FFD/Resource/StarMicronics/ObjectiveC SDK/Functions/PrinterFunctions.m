//
//  PrinterFunctions.m
//  ObjectiveC SDK
//
//  Created by Yuji on 2015/**/**.
//  Copyright (c) 2015年 Star Micronics. All rights reserved.
//

#import "PrinterFunctions.h"

@implementation PrinterFunctions

+ (NSData *)createTextReceiptData:(StarIoExtEmulation)emulation
                 localizeReceipts:(ILocalizeReceipts *)localizeReceipts
                             utf8:(BOOL)utf8 {
    ISCBBuilder *builder = [StarIoExt createCommandBuilder:emulation];
    
    [builder beginDocument];
    
    [localizeReceipts appendTextReceiptData:builder utf8:utf8];
    
    [builder appendCutPaper:SCBCutPaperActionPartialCutWithFeed];
    
    [builder endDocument];
    
    return [builder.commands copy];
}

+ (NSData *)createRasterReceiptData:(StarIoExtEmulation)emulation
                   localizeReceipts:(ILocalizeReceipts *)localizeReceipts {
    UIImage *image = [localizeReceipts createRasterReceiptImage];
    
    ISCBBuilder *builder = [StarIoExt createCommandBuilder:emulation];
    
    [builder beginDocument];
    
    [builder appendBitmap:image diffusion:NO];
    
    [builder appendCutPaper:SCBCutPaperActionPartialCutWithFeed];
    
    [builder endDocument];
    
    return [builder.commands copy];
}

+ (NSData *)createScaleRasterReceiptData:(StarIoExtEmulation)emulation
                        localizeReceipts:(ILocalizeReceipts *)localizeReceipts
                                   width:(NSInteger)width
                               bothScale:(BOOL)bothScale {
    UIImage *image = [localizeReceipts createScaleRasterReceiptImage];
    
    ISCBBuilder *builder = [StarIoExt createCommandBuilder:emulation];
    
    [builder beginDocument];
    
    [builder appendBitmap:image diffusion:NO width:width bothScale:bothScale];
    
    [builder appendCutPaper:SCBCutPaperActionPartialCutWithFeed];
    
    [builder endDocument];
    
    return [builder.commands copy];
}

+ (NSData *)createCouponData:(StarIoExtEmulation)emulation
            localizeReceipts:(ILocalizeReceipts *)localizeReceipts
                       width:(NSInteger)width
                    rotation:(SCBBitmapConverterRotation)rotation {
    UIImage *image = [localizeReceipts createCouponImage];
    
    ISCBBuilder *builder = [StarIoExt createCommandBuilder:emulation];
    
    [builder beginDocument];
    
    [builder appendBitmap:image diffusion:NO width:width bothScale:YES rotation:rotation];
    
    [builder appendCutPaper:SCBCutPaperActionPartialCutWithFeed];
    
    [builder endDocument];
    
    return [builder.commands copy];
}

@end
