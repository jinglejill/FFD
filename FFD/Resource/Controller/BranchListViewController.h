//
//  BranchListViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 4/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"

@interface BranchListViewController : CustomViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *colVwBranch;
@property (strong, nonatomic) IBOutlet UISearchBar *sbText;
- (IBAction)addBranch:(id)sender;
- (IBAction)backToSetting:(id)sender;
- (IBAction)unwindToBranchList:(UIStoryboardSegue *)segue;

@end
