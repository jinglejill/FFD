//
//  CustomCollectionViewCellBranch.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewCellBranch : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblBranchNo;
@property (strong, nonatomic) IBOutlet UILabel *lblBranchName;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
@property (strong, nonatomic) IBOutlet UIButton *btnMap;
@property (strong, nonatomic) IBOutlet UILabel *lblPhoneNo;
@property (strong, nonatomic) IBOutlet UILabel *lblTableNum;
@property (strong, nonatomic) IBOutlet UILabel *lblEmployeeNum;
@property (strong, nonatomic) IBOutlet UILabel *lblCustomerNum;
@property (strong, nonatomic) IBOutlet UIImageView *imgVwStatus;
@property (strong, nonatomic) IBOutlet UIButton *btnEdit;

@end
