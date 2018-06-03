//
//  CustomCollectionViewCellMenuWithTakeAway.m
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/7/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomCollectionViewCellMenuWithTakeAway.h"

@implementation CustomCollectionViewCellMenuWithTakeAway
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
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    UIColor *color = UIColorFromRGB([Utility hexStringToInt:menu.color]);
//    self.backgroundColor = color;
    [self makeBottomRightRoundedCorner:self.vwRoundedCorner];
}


-(void)makeBottomRightRoundedCorner:(UIView *)view
{
    // Create the path (with only the top-left corner rounded)
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                                   byRoundingCorners:UIRectCornerBottomRight
                                                         cornerRadii:CGSizeMake(100.0, 100.0)];
    
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    
    // Set the newly created shape layer as the mask for the image view's layer
    view.layer.mask = maskLayer;
}
@end
