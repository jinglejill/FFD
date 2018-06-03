//
//  CustomPrintPageRenderer.m
//  testPdf
//
//  Created by Thidaporn Kijkamjai on 1/27/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomPrintPageRenderer.h"

@implementation CustomPrintPageRenderer

- (id)init
{
    self = [super init];
    _pageWidth = 595.2;
    _pageHeight = 841.8;
    
    
    CGRect pageFrame = CGRectMake(0, 0, _pageWidth, _pageHeight);
    CGRect inset = CGRectInset(pageFrame, 10, 10);
    [self setValue:[NSValue value:&pageFrame withObjCType:@encode(CGRect)] forKey:@"paperRect"];
    [self setValue:[NSValue value:&inset withObjCType:@encode(CGRect)] forKey:@"printableRect"];
    
    
    return self;
}

- (id)initWithPageWidth:(float)width height:(float)height
{
    self = [super init];
    _pageWidth = width;    
    _pageHeight = height;
    
    
    
    
    CGRect pageFrame = CGRectMake(0, 0, _pageWidth, _pageHeight);
    CGRect inset = CGRectInset(pageFrame, 10, 10);
    [self setValue:[NSValue value:&pageFrame withObjCType:@encode(CGRect)] forKey:@"paperRect"];
    [self setValue:[NSValue value:&inset withObjCType:@encode(CGRect)] forKey:@"printableRect"];
    
    
    return self;
}

- (NSString *)exportHTMLContentToPDF:(NSMutableArray *)htmlContentList fileName:(NSString *)fileName
{
    NSMutableArray *printPageRendererList = [[NSMutableArray alloc]init];
    for(int i=0; i<[htmlContentList count]; i++)
    {
        NSString *htmlContent = htmlContentList[i];
        UIMarkupTextPrintFormatter *printFormatter = [[UIMarkupTextPrintFormatter alloc]initWithMarkupText:htmlContent];
        [self addPrintFormatter:printFormatter startingAtPageAtIndex:i];
        [printPageRendererList addObject:self];
    }
    
    NSData *pdfData = [self drawPDFUsingPrintPageRenderer:printPageRendererList];
    
    
    NSString *pdfFileName = [NSString stringWithFormat:@"%@/%@.pdf",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0],fileName];
    
    
    [pdfData writeToFile:pdfFileName atomically:YES];
    NSLog(@"pdf filename: %@",pdfFileName);
    
    return pdfFileName;
}

- (NSData *)drawPDFUsingPrintPageRenderer:(NSMutableArray *)printPageRendererList
{
    NSMutableData *data = [[NSMutableData alloc]init];
    UIGraphicsBeginPDFContextToData(data, CGRectZero, nil);
    
    
    for(int i=0; i<[printPageRendererList count]; i++)
    {
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, _pageWidth, _pageHeight), NULL);
        [printPageRendererList[i] drawPageAtIndex:i inRect:UIGraphicsGetPDFContextBounds()];
    }
    
    
    UIGraphicsEndPDFContext();
    return data;
}
@end
