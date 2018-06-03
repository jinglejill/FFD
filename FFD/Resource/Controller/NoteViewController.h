//
//  NoteViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 11/15/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "OrderTakingViewController.h"
#import "OrderTaking.h"


@interface NoteViewController : CustomViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) NSMutableArray *noteList;
@property (strong, nonatomic) OrderTaking *orderTaking;
@property (strong, nonatomic) OrderTakingViewController *vc;
@property (strong, nonatomic) IBOutlet UICollectionView *colVwNote;
@property (strong, nonatomic) IBOutlet UIButton *btnConfirm;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
- (IBAction)confirmNote:(id)sender;
- (IBAction)cancelNote:(id)sender;

@end
