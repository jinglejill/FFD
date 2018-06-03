//
//  CustomCollectionViewCellReceiptHistoryList.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/6/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewCellReceiptHistoryList : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblDateTime;
@property (strong, nonatomic) IBOutlet UILabel *lblReceiptNo;
@property (strong, nonatomic) IBOutlet UILabel *lblTableName;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalAmount;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressGestureRecognizer;
@end
