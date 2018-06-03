//
//  CustomCollectionViewCellMenuWithTakeAway.h
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/7/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewCellMenuWithTakeAway : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIButton *btnMenuName;
@property (strong, nonatomic) IBOutlet UIButton *btnTakeAway;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (strong, nonatomic) IBOutlet UIView *vwRoundedCorner;

@end
