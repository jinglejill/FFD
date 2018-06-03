//
//  AddressViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/21/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//


#import "CustomViewController.h"
#import "ReceiptViewController.h"
#import "ConfirmAndCancelView.h"
#import "Address.h"


@interface AddressViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic) NSInteger memberID;
@property (strong, nonatomic) CustomViewController *vc;
@property (strong, nonatomic) Address *editAddress;
@property (strong, nonatomic) NSMutableArray *addressList;
@property (nonatomic) NSInteger firstAddressFlag;
@property (strong, nonatomic) IBOutlet UITableView *tbvAddress;
@property (strong, nonatomic) ConfirmAndCancelView *vwConfirmAndCancel;
@end
