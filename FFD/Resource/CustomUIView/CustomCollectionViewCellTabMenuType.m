//
//  CustomCollectionViewCellTabMenuType.m
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/7/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomCollectionViewCellTabMenuType.h"

@implementation CustomCollectionViewCellTabMenuType
@synthesize longPressGestureRecognizer;


- (IBAction)selectMenuType:(id)sender {
}

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
