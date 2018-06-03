//
//  EmployeeLIstViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 4/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"

@interface EmployeeLIstViewController : CustomViewController
@property (strong, nonatomic) IBOutlet UICollectionView *colVwEmployee;
@property (strong, nonatomic) IBOutlet UISearchBar *sbText;
@property (strong, nonatomic) IBOutlet UITextField *txtBranch;
@property (strong, nonatomic) IBOutlet UILabel *lblBranch;
@property (strong, nonatomic) IBOutlet UIPickerView *pvBranch;

@end
