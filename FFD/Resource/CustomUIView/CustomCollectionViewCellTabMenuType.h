//
//  CustomCollectionViewCellTabMenuType.h
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/7/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewCellTabMenuType : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblMenuType;
@property (strong, nonatomic) IBOutlet UIView *vwBottomBorder;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressGestureRecognizer;
- (IBAction)selectMenuType:(id)sender;

@end
