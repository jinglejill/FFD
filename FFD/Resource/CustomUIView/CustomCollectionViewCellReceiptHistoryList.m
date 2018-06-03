//
//  CustomCollectionViewCellReceiptHistoryList.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/6/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomCollectionViewCellReceiptHistoryList.h"

@implementation CustomCollectionViewCellReceiptHistoryList
@synthesize longPressGestureRecognizer;


- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]init];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    float labelSpace = self.frame.size.width - 16*2 - 8*3;
    float labelSpaceXib = 378 - 16*2 - 8*3;
    {
        CGRect frame = self.lblDateTime.frame;
        frame.size.width = 125/labelSpaceXib*labelSpace;
        self.lblDateTime.frame = frame;
        NSLog(@"lblDateTime frame: (%f,%f,%f,%f)",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
    }
    {
        CGRect frame = self.lblReceiptNo.frame;
        frame.size.width = 110/labelSpaceXib*labelSpace;
        frame.origin.x = self.lblDateTime.frame.origin.x + self.lblDateTime.frame.size.width + 8;
        self.lblReceiptNo.frame = frame;
        NSLog(@"lblReceiptNo frame: (%f,%f,%f,%f)",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
    }
    {
        CGRect frame = self.lblTableName.frame;
        frame.size.width = 39/labelSpaceXib*labelSpace;
        frame.origin.x = self.lblReceiptNo.frame.origin.x + self.lblReceiptNo.frame.size.width + 8;
        self.lblTableName.frame = frame;
        NSLog(@"lblTableName frame: (%f,%f,%f,%f)",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
    }
    {
        CGRect frame = self.lblTotalAmount.frame;
        frame.size.width = 48/labelSpaceXib*labelSpace;
        frame.origin.x = self.lblTableName.frame.origin.x + self.lblTableName.frame.size.width + 8;
        self.lblTotalAmount.frame = frame;
        NSLog(@"lblTotalAmount frame: (%f,%f,%f,%f)",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
    }
}
@end
