//
//  CustomCollectionViewCellLabelTextView.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewCellLabelTextView : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UITextView *txtValue;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblWidthConstant;
@end
