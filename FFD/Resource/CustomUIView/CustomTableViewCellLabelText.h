//
//  CustomTableViewCellLabelText.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/21/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCellLabelText : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UITextField *txtValue;
@property (strong, nonatomic) IBOutlet UILabel *lblWidthConstant;
@end
