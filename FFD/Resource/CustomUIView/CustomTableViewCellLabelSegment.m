//
//  CustomTableViewCellLabelSegment.m
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/17/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomTableViewCellLabelSegment.h"

@implementation CustomTableViewCellLabelSegment

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
    NSLog(@"reuse");
    _segConGender.selectedSegmentIndex = 0;
}
@end
