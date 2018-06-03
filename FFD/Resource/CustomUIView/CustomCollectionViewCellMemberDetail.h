//
//  CustomCollectionViewCellMemberDetail.h
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/17/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>



//@protocol CustomCollectionViewCellMemberDetailDelegate
//- (void)cellWasTapped:(UICollectionViewCell *)cell;
// @end


@interface CustomCollectionViewCellMemberDetail : UICollectionViewCell


@property (strong, nonatomic) IBOutlet UIView *vwColor1;
@property (strong, nonatomic) IBOutlet UIView *vwColor2;
@property (strong, nonatomic) IBOutlet UIView *vwColor3;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblValue;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressGestureRecognizer;
@end
