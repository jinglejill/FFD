//
//  CustomCollectionViewCellLabelSwitchButton.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 29/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomCollectionViewCellLabelSwitchButton.h"

@implementation CustomCollectionViewCellLabelSwitchButton
@synthesize vwTopBorder;
@synthesize vwLeftBorder;
@synthesize vwRightBorder;

- (void)prepareForReuse {
    [super prepareForReuse];
    vwTopBorder.backgroundColor = [UIColor clearColor];
    vwLeftBorder.backgroundColor = [UIColor clearColor];
    vwLeftBorder.backgroundColor = [UIColor clearColor];
}
@end
