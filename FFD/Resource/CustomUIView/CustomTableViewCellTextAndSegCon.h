//
//  CustomTableViewCellTextAndSegCon.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface CustomTableViewCellTextAndSegCon : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UITextField *txtValue;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segConValue;
@end
