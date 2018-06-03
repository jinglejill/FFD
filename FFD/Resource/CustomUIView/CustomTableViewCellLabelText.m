//
//  CustomTableViewCellLabelText.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/21/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomTableViewCellLabelText.h"

@implementation CustomTableViewCellLabelText

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
