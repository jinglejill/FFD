//
//  CustomCollectionViewCellTextAndLabel.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/27/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewCellTextAndLabel : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UITextField *txtText;
@property (strong, nonatomic) IBOutlet UILabel *lblTextLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblTrailingConstant;
@property (strong, nonatomic) IBOutlet UITextField *txtLeadingConstant;
@end
