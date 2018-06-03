//
//  CustomCollectionViewCellText.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/22/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomCollectionViewCellText.h"

@implementation CustomCollectionViewCellText
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
