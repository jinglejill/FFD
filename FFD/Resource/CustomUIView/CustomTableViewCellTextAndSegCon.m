//
//  CustomTableViewCellTextAndSegCon.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomTableViewCellTextAndSegCon.h"

@implementation CustomTableViewCellTextAndSegCon

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    _txtValue.text = @"";
}
@end
