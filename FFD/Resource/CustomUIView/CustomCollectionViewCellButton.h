//
//  CustomCollectionViewCellButton.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewCellButton : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIButton *btnValue;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btnHeightConstant;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btnWidthConstant;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btnLeadingConstant;

@end
