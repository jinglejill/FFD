//
//  CustomTableViewCellLabelLabel2.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 15/5/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCellLabelLabel2 : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblText;
@property (strong, nonatomic) IBOutlet UILabel *lblValue;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblTextWidthConstant;

@end
