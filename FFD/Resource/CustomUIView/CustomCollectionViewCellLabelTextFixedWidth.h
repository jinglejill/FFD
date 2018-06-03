//
//  CustomCollectionViewCellLabelTextFixedWidth.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 11/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewCellLabelTextFixedWidth : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UITextField *txtValue;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblWidthConstant;
@end
