//
//  CustomCollectionViewCellLabel.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 25/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewCellLabel : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblTextLabel;
@property (strong, nonatomic) IBOutlet UIView *vwTopBorder;
@property (strong, nonatomic) IBOutlet UIView *vwRightBorder;
@property (strong, nonatomic) IBOutlet UIView *vwLeftBorder;
@end
