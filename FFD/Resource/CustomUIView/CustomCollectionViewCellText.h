//
//  CustomCollectionViewCellText.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/22/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewCellText : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UITextField *txtText;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *txtLeadingConstant;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *txtTrailingConstant;
@property (strong, nonatomic) IBOutlet UIView *vwLeftBorder;
@property (strong, nonatomic) IBOutlet UIView *vwRightBorder;
@property (strong, nonatomic) IBOutlet UIView *vwTopBorder;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *txtHeightConstant;
@end
