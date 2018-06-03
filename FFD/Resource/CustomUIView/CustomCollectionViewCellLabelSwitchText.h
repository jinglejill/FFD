//
//  CustomCollectionViewCellLabelSwitchText.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 25/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewCellLabelSwitchText : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UISwitch *swtValue;
@property (strong, nonatomic) IBOutlet UILabel *lblTextLabel;
@property (strong, nonatomic) IBOutlet UITextField *txtTextValue;
@property (strong, nonatomic) IBOutlet UIButton *btnTrash;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblLeadingConstant;
@end
