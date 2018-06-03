//
//  SettingViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 24/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"

@interface SettingViewController : CustomViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IBOutlet UICollectionView *colVwMenu;
- (IBAction)unwindToSetting:(UIStoryboardSegue *)segue;
@end
