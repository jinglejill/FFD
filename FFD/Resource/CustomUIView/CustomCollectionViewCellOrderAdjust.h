//
//  CustomCollectionViewCellOrderAdjust.h
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/7/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewCellOrderAdjust : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblMenuName;
@property (strong, nonatomic) IBOutlet UILabel *lblNote;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblQuantity;
@property (strong, nonatomic) IBOutlet UIButton *btnMoveToTrash;
@property (strong, nonatomic) IBOutlet UIButton *btnAddNote;
@property (strong, nonatomic) IBOutlet UIButton *btnIncrement;
@property (strong, nonatomic) IBOutlet UIButton *btnDecrement;

@end
