//
//  CustomCollectionViewCellLabelAndSwitch.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 25/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomCollectionViewCellLabelAndSwitch.h"

@implementation CustomCollectionViewCellLabelAndSwitch
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
