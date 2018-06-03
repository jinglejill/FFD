//
//  CustomCollectionViewCellReceiptOrder.h
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/16/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewCellReceiptOrder : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblMenuName;
@property (strong, nonatomic) IBOutlet UILabel *lblNote;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblQuantity;
@end
