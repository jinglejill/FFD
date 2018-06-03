//
//  SetUpPrinterViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 24/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"

@interface SetUpPrinterViewController : CustomViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIPopoverPresentationControllerDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *colVwSetUpPrinter;
@property (strong, nonatomic) IBOutlet UICollectionView *colVwStatus;
@property (strong, nonatomic) IBOutlet UIButton *btnRefreshStatus;
@property (strong, nonatomic) IBOutlet UISwitch *swPrinterOn;


- (IBAction)unwindToSetUpPrinter:(UIStoryboardSegue *)segue;
- (IBAction)backToSetting:(id)sender;
- (IBAction)refreshStatus:(id)sender;
- (IBAction)printerSwitchChanged:(id)sender;
-(void)setFoodCheckListTextBox:(NSString *)printerName;
- (IBAction)setUpMenuTypePrint:(id)sender;
@end
