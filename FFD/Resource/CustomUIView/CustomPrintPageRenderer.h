//
//  CustomPrintPageRenderer.h
//  testPdf
//
//  Created by Thidaporn Kijkamjai on 1/27/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomPrintPageRenderer : UIPrintPageRenderer
@property (nonatomic) CGFloat pageWidth;
@property (nonatomic) CGFloat pageHeight;

- (id)init;
- (id)initWithPageWidth:(float)width height:(float)height;
- (NSString *)exportHTMLContentToPDF:(NSMutableArray *)htmlContentList fileName:(NSString *)fileName;
@end
