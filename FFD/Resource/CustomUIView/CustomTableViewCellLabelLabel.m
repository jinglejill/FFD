//
//  CustomTableViewCell.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/11/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell
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


@end
