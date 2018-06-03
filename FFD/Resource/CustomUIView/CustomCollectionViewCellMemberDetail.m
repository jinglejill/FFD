//
//  CustomCollectionViewCellMemberDetail.m
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/17/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomCollectionViewCellMemberDetail.h"



@implementation CustomCollectionViewCellMemberDetail
@synthesize longPressGestureRecognizer;

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]init];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    NSLog(@"reuse");
    
    self.vwColor1.backgroundColor = [UIColor clearColor];
    self.vwColor2.backgroundColor = [UIColor clearColor];
    self.vwColor3.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    {
        CGRect frame = self.vwColor1.frame;
        frame.origin.x = 67;
        self.vwColor1.frame = frame;
    }
    {
        CGRect frame = self.vwColor2.frame;
        frame.origin.x = 67+15;
        self.vwColor2.frame = frame;
    }
    {
        CGRect frame = self.vwColor3.frame;
        frame.origin.x = 67+15+15;
        self.vwColor3.frame = frame;
    }
    NSArray *arrText = [self.lblTitle.text componentsSeparatedByString:@" "];
    if([arrText count]>0)
    {
        if([arrText[0] isEqualToString:@"ที่อยู่"])
        {
            CGRect frame = self.lblValue.frame;
            frame.origin.x = 124;
            frame.size.width = self.frame.size.width - 124 - 16;
            self.lblValue.frame = frame;
        }
    }
//    if(self.tag == 60)
//            self.lblTitle.layer.borderWidth = 1;
    

}
@end
