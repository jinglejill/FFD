//
//  CustomCollectionViewCell.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/22/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblTextLabel;
@property (strong, nonatomic) IBOutlet UIView *vwLeftBorder;
@property (strong, nonatomic) IBOutlet UIView *vwTopBorder;
@property (strong, nonatomic) IBOutlet UIView *vwRightBorder;
@property (strong, nonatomic) IBOutlet UIView *vwBottomBorder;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressGestureRecognizer;
@end
