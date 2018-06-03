//
//  CustomCollectionViewCellCustomerTable.h
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/6/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewCellCustomerTable : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTableName;
@property (strong, nonatomic) IBOutlet UIImageView *imgVwOccupying;
@property (strong, nonatomic) IBOutlet UIView *vwLeftBorder;
@property (strong, nonatomic) IBOutlet UIView *vwRightBorder;
@property (strong, nonatomic) IBOutlet UIView *vwTopBorder;
@property (strong, nonatomic) IBOutlet UIView *vwBottomBorder;

@end
