//
//  SetUpCashDrawerViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 29/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"

@interface SetUpCashDrawerViewController : CustomViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIPopoverPresentationControllerDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *colVwSetUpCashDrawer;

- (IBAction)unwindToSetUpCashDrawer:(UIStoryboardSegue *)segue;
- (IBAction)backToSetting:(id)sender;
@end
