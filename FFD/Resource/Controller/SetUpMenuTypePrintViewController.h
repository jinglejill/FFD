//
//  SetUpMenuTypePrintViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 25/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"

@interface SetUpMenuTypePrintViewController : CustomViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIPopoverPresentationControllerDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *colVwSetUpMenuTypePrint;
- (IBAction)backToSetting:(id)sender;
-(void)reloadCollectionView;
@end
