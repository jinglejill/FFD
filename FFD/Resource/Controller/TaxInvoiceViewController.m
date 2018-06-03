//
//  TaxInvoiceViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 11/21/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "TaxInvoiceViewController.h"
#import "AddressViewController.h"
#import "CustomCollectionViewCellMemberDetail.h"
#import "CustomTableViewCellLabelText.h"
#import "CustomTableViewCellLabelSegment.h"
#import "CustomCollectionViewCellAddAddress.h"
#import "ConfirmAndCancelView.h"
#import "CustomPrintPageRenderer.h"
#import "InvoiceComposer.h"
#import "Member.h"
#import "Setting.h"
#import "ReceiptNoTax.h"
#import "RewardPoint.h"
#import "OrderTaking.h"
#import "Menu.h"
#import "OrderNote.h"


//part printer
#import "AppDelegate.h"
#import "Communication.h"
#import "PrinterFunctions.h"
#import "ILocalizeReceipts.h"


@interface TaxInvoiceViewController ()
{
    Member *_member;
    NSInteger _memberDetailNoOfItem;
    NSMutableArray *_addressList;
    NSMutableArray *_htmlContentList;
    UIWebView *_webview;
    UIWebView *_webview2;
    UIView *_backgroundView;
    BOOL _print;
    Member *_editingMember;
}
@end

@implementation TaxInvoiceViewController
static NSString * const reuseIdentifierMemberDetail = @"CustomCollectionViewCellMemberDetail";
static NSString * const reuseIdentifierLabelText = @"CustomTableViewCellLabelText";
static NSString * const reuseIdentifierLabelSegment = @"CustomTableViewCellLabelSegment";
static NSString * const reuseIdentifierAddAddress = @"CustomCollectionViewCellAddAddress";


@synthesize tbvMemberRegister;
@synthesize colVwMemberDetail;
@synthesize dtPicker;
@synthesize lblMemberNo;
@synthesize txtMemberNo;
@synthesize btnMemberRegister;
@synthesize btnPrintTaxInvoice;
@synthesize vwConfirmAndCancel;
@synthesize receipt;
@synthesize orderTakingList;
@synthesize strTotalQuantity;
@synthesize strSubTotalAmount;
@synthesize strDiscountAmount;
@synthesize strAfterDiscountAmount;
@synthesize strServiceCharge;
@synthesize strVat;
@synthesize strRounding;
@synthesize strTotalAmount;


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([textField isEqual:txtMemberNo])
    {
        //get member detail
        [self reloadMemberDetail];
        [self updateMemberInReceipt];
        [self viewTaxInvoice];
    }
    switch (textField.tag)
    {
        case 1:
            _editingMember.fullName = [Utility trimString:textField.text];
            break;
        case 2:
            _editingMember.nickname = [Utility trimString:textField.text];
            break;
        case 3:
            _editingMember.phoneNo = [Utility trimString:textField.text];
            break;
        case 4:
            _editingMember.birthDate = [Utility stringToDate:textField.text fromFormat:@"d MMM yyyy"];
            break;
        default:
            break;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    if(textField.tag == 4)
    {
        NSString *strDate = textField.text;
        if([strDate isEqualToString:@""])
        {
            NSInteger year = [[Utility dateToString:[Utility currentDateTime] toFormat:@"yyyy"] integerValue];
            NSString *strDefaultDate = [NSString stringWithFormat:@"01/01/%ld",year-20];
            NSDate *datePeriod = [Utility stringToDate:strDefaultDate fromFormat:@"dd/MM/yyyy"];
            [dtPicker setDate:datePeriod];
        }
        else
        {
            NSDate *datePeriod = [Utility stringToDate:strDate fromFormat:@"d MMM yyyy"];
            [dtPicker setDate:datePeriod];
        }
    }
}

- (IBAction)datePickerChanged:(id)sender
{
    UITextField *textField = (UITextField *)[self.view viewWithTag:4];
    if([textField isFirstResponder])
    {
        textField.text = [Utility dateToString:dtPicker.date toFormat:@"d MMM yyyy"];
    }
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    {
        CGRect frame = tbvMemberRegister.frame;
        frame.size.width = 350;
        frame.size.height = 264;
        tbvMemberRegister.frame = frame;
    }
    
    {
        CGRect frame = colVwMemberDetail.frame;
        frame.origin.x = self.view.frame.size.width*0.5 + 8;
        frame.size.width = self.view.frame.size.width-frame.origin.x;
        colVwMemberDetail.frame = frame;
    }
    
    
    {
        CGRect frame = lblMemberNo.frame;
        frame.origin.x = self.view.frame.size.width*0.5 + 8;
        lblMemberNo.frame = frame;
    }
    
    
    {
        CGRect frame = txtMemberNo.frame;
        frame.origin.x = lblMemberNo.frame.origin.x+lblMemberNo.frame.size.width+8;
        frame.size.width = self.view.frame.size.width - frame.origin.x;
        txtMemberNo.frame = frame;
    }
    
    {
        CGRect frame = _webview.frame;
        frame.origin.x = 0;
        frame.origin.y = lblMemberNo.frame.origin.y;
        frame.size.width = self.view.frame.size.width*0.5;
        frame.size.height = self.view.frame.size.height - frame.origin.y;
        _webview.frame = frame;
    }
    
}

- (void) orientationChanged:(NSNotification *)note
{
    if([tbvMemberRegister isDescendantOfView:self.view])
    {
        tbvMemberRegister.center = CGPointMake(self.view.frame.size.height/2, self.view.frame.size.width/2);
    }
    
    
    UIDevice * device = note.object;
    switch(device.orientation)
    {
        case UIDeviceOrientationPortrait:
            /* start special animation */
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            /* start special animation */
            break;
            
        default:
            break;
    };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // Do any additional setup after loading the view.
    colVwMemberDetail.delegate = self;
    colVwMemberDetail.dataSource = self;
    
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierMemberDetail bundle:nil];
        [colVwMemberDetail registerNib:nib forCellWithReuseIdentifier:reuseIdentifierMemberDetail];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierAddAddress bundle:nil];
        [colVwMemberDetail registerNib:nib forCellWithReuseIdentifier:reuseIdentifierAddAddress];
    }
    
    
    
    
    [[NSBundle mainBundle] loadNibNamed:@"TableViewMemberRegister" owner:self options:nil];
    
    tbvMemberRegister.delegate = self;
    tbvMemberRegister.dataSource = self;
    CGRect frame = tbvMemberRegister.frame;
    frame.size.width = 350;
    frame.size.height = 264;
    tbvMemberRegister.frame = frame;
    tbvMemberRegister.backgroundColor = [UIColor whiteColor];
    [self setShadow:tbvMemberRegister radius:48];
    tbvMemberRegister.layer.cornerRadius = 16;
    
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelText bundle:nil];
        [tbvMemberRegister registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelText];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelSegment bundle:nil];
        [tbvMemberRegister registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelSegment];
    }
    
    
    
    //add ยืนยัน กับ ยกเลิก button
    [[NSBundle mainBundle] loadNibNamed:@"ConfirmAndCancelView" owner:self options:nil];
    tbvMemberRegister.tableFooterView = vwConfirmAndCancel;
    [vwConfirmAndCancel.btnConfirm addTarget:self action:@selector(confirmRegister:) forControlEvents:UIControlEventTouchUpInside];
    [vwConfirmAndCancel.btnCancel addTarget:self action:@selector(cancelRegister:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
    [self.tabBarController.tabBar setFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
}

- (void)loadView
{
    [super loadView];
    
    
    _memberDetailNoOfItem = 6;
    txtMemberNo.delegate = self;
    _htmlContentList = [[NSMutableArray alloc]init];
    
    
    
    
    //use webview for calculate pdf page size
    _backgroundView = [[UIView alloc]initWithFrame:self.view.frame];
    _backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:_backgroundView atIndex:0];
    _webview2=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 580,100)];
    _webview2.delegate = self;
    
    
    
    
    
    _webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 1024,768)];
    _webview.delegate = self;
    _webview.scalesPageToFit = YES;
    [self setShadow:_webview];
    [self.view addSubview:_webview];
    //    [self.view insertSubview:_webview atIndex:0];
    
    
    
    
    [self setShadow:colVwMemberDetail];
    [self setButtonDesign:btnPrintTaxInvoice];
    
    
    
    [dtPicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dtPicker removeFromSuperview];
    
    
    
    [self loadViewProcess];
}

- (void)loadViewProcess
{
    if([Utility isStringEmpty:receipt.receiptNoTaxID])
    {
        [self loadingOverlayView];
        receipt.modifiedUser = [Utility modifiedUser];
        receipt.modifiedDate = [Utility currentDateTime];
        [self.homeModel insertItems:dbReceiptAndReceiptNoTaxPrint withData:receipt actionScreen:@"insert process when print tax invoice in tax invoice screen"];
    }
    else
    {
        if(receipt.memberID != 0)
        {
            Member *member = [Member getMember:receipt.memberID];
            txtMemberNo.text = member.phoneNo;
        }
        [self reloadMemberDetail];
        [self viewTaxInvoice];
    }
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToReceiptHistory" sender:self];
}

- (IBAction)registerMember:(id)sender
{
    //show note box to select
    _editingMember = [[Member alloc]init];
    
    
    
    tbvMemberRegister.center = CGPointMake(colVwMemberDetail.frame.origin.x + colVwMemberDetail.frame.size.width/2, colVwMemberDetail.frame.size.height/2);
    CGRect frame = tbvMemberRegister.frame;
    frame.size.width = 350;
    frame.size.height = 264;
    tbvMemberRegister.frame = frame;
    [tbvMemberRegister reloadData];
    NSLog(@"tableview frame: (%f,%f,%f,%f)",tbvMemberRegister.frame.origin.x,tbvMemberRegister.frame.origin.y,tbvMemberRegister.frame.size.width,tbvMemberRegister.frame.size.height);
    
    
    {
        tbvMemberRegister.alpha = 0.0;
        [self.view addSubview:tbvMemberRegister];
        [UIView animateWithDuration:0.2 animations:^{
            tbvMemberRegister.alpha = 1.0;
        }];
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return  1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if([collectionView isEqual:colVwMemberDetail])
    {
        return _memberDetailNoOfItem;
    }
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSInteger item = indexPath.item;
    if([collectionView isEqual:colVwMemberDetail])
    {
        if(_member)
        {
            if(item < 6)
            {
                CustomCollectionViewCellMemberDetail *cell = (CustomCollectionViewCellMemberDetail*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierMemberDetail forIndexPath:indexPath];
                cell.contentView.userInteractionEnabled = NO;
                cell.backgroundColor = [UIColor clearColor];
                
                
                switch (item)
                {
                    case 0:
                    {
                        cell.lblTitle.text = @"ชื่อ:";
                        cell.lblValue.text = _member.fullName;
                    }
                        break;
                    case 1:
                    {
                        cell.lblTitle.text = @"ชื่อเล่น:";
                        cell.lblValue.text = _member.nickname;
                    }
                        break;
                    case 2:
                    {
                        cell.lblTitle.text = @"เบอร์โทร:";
                        cell.lblValue.text = _member.phoneNo;
                    }
                        break;
                    case 3:
                    {
                        cell.lblTitle.text = @"วันเกิด:";
                        if(!_member.birthDate)
                        {
                            cell.lblValue.text = @"";
                        }
                        else
                        {
                            cell.lblValue.text = [Utility dateToString:_member.birthDate toFormat:@"d MMM yyyy"];
                        }
                    }
                        break;
                    case 4:
                    {
                        cell.lblTitle.text = @"เพศ:";
                        cell.lblValue.text = _member.gender;
                    }
                        break;
                    case 5:
                    {
                        NSInteger totalPoint = [RewardPoint getTotalPointWithMemberID:_member.memberID];
                        NSString *strTotalPoint = [Utility formatDecimal:totalPoint withMinFraction:0 andMaxFraction:0];
                        cell.lblTitle.text = @"แต้มสะสม:";
                        cell.lblValue.text = strTotalPoint;
                    }
                        break;
                    default:
                        break;
                }
                
                
                CGSize labelSize = [self suggestedSizeWithFont:cell.lblValue.font size:CGSizeMake(colVwMemberDetail.frame.size.width - 16 - 16 - 59.5 - 8, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:cell.lblValue.text];
                
                
                CGRect frame = cell.lblValue.frame;
                frame.size.height = labelSize.height;
                cell.lblValue.frame = frame;
                
                
                
                [cell.lblValue removeGestureRecognizer:cell.longPressGestureRecognizer];
                return cell;
            }
            else if(item == 6)
            {
                CustomCollectionViewCellAddAddress *cell = (CustomCollectionViewCellAddAddress*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierAddAddress forIndexPath:indexPath];
                cell.contentView.userInteractionEnabled = NO;
                cell.backgroundColor = [UIColor clearColor];
                
                
                [cell.btnAddAddress addTarget:self action:@selector(addAddress:) forControlEvents:UIControlEventTouchUpInside];
                
                
                return cell;
            }
            else if(item > 6)
            {
                CustomCollectionViewCellMemberDetail *cell = (CustomCollectionViewCellMemberDetail*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierMemberDetail forIndexPath:indexPath];
                cell.contentView.userInteractionEnabled = NO;
                
                
                Address *address = _addressList[item - 1 - 6];
                if([_addressList count] == 1)
                {
                    cell.lblValue.text = [Address getFullAddress:address];
                    cell.lblTitle.text = @"ที่อยู่:";
                }
                else
                {
                    cell.lblValue.text = [Address getFullAddress:address];
                    cell.lblTitle.text = [NSString stringWithFormat:@"ที่อยู่ %ld:",item - 1 - 6 + 1];
                }
                
                
                NSMutableArray *colorList = [[NSMutableArray alloc]init];
                if(address.keyAddressFlag)
                {
                    [colorList addObject:[UIColor colorWithRed:255.0/255 green:204.0/255 blue:0 alpha:1]];
                }
                if(address.deliveryAddressFlag)
                {
                    [colorList addObject:[UIColor colorWithRed:90.0/255 green:200.0/255 blue:250.0/255 alpha:1]];
                }
                if(address.taxAddressFlag)
                {
                    [colorList addObject:[UIColor colorWithRed:0/255 green:122.0/255 blue:255.0/255 alpha:1]];
                }
                if([colorList count]>0)
                {
                    cell.vwColor1.backgroundColor = colorList[0];
                }
                if([colorList count]>1)
                {
                    cell.vwColor2.backgroundColor = colorList[1];
                }
                if([colorList count]>2)
                {
                    cell.vwColor3.backgroundColor = colorList[2];
                }
                
                
                CGSize labelSize = [self suggestedSizeWithFont:cell.lblValue.font size:CGSizeMake(colVwMemberDetail.frame.size.width - 16 - 16 - 59.5 - 8, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:cell.lblValue.text];
                
                
                CGRect frame = cell.lblValue.frame;
                frame.size.height = labelSize.height;
                cell.lblValue.frame = frame;
                
                
                
                cell.lblValue.userInteractionEnabled = YES;
                [cell.lblValue removeGestureRecognizer:cell.longPressGestureRecognizer];
                [cell.longPressGestureRecognizer addTarget:self action:@selector(handleLongPress:)];
                [cell.lblValue addGestureRecognizer:cell.longPressGestureRecognizer];
                
                
                
                return cell;
            }
        }
        else
        {
            CustomCollectionViewCellMemberDetail *cell = (CustomCollectionViewCellMemberDetail*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierMemberDetail forIndexPath:indexPath];
            cell.contentView.userInteractionEnabled = NO;
            cell.backgroundColor = [UIColor clearColor];
            
            switch (item) {
                case 0:
                {
                    cell.lblTitle.text = @"ชื่อ:";
                    cell.lblValue.text = @"";
                }
                    break;
                case 1:
                {
                    cell.lblTitle.text = @"ชื่อเล่น:";
                    cell.lblValue.text = @"";
                }
                    break;
                case 2:
                {
                    cell.lblTitle.text = @"เบอร์โทร:";
                    cell.lblValue.text = @"";
                }
                    break;
                case 3:
                {
                    cell.lblTitle.text = @"วันเกิด:";
                    cell.lblValue.text = @"";
                }
                    break;
                case 4:
                {
                    cell.lblTitle.text = @"เพศ:";
                    cell.lblValue.text = @"";
                }
                    break;
                case 5:
                {
                    cell.lblTitle.text = @"แต้มสะสม:";
                    cell.lblValue.text = @"";
                }
                    break;
                default:
                    break;
            }
            
            
            
            [cell.lblValue removeGestureRecognizer:cell.longPressGestureRecognizer];
            return cell;
        }
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeMake(0, 0);
    NSInteger item = indexPath.item;
    if([collectionView isEqual:colVwMemberDetail])
    {
        if(!_member)
        {
            size = CGSizeMake(colVwMemberDetail.frame.size.width,44);
            return size;
        }
        //load member มาโชว์
        NSString *strValue = @"";
        if(item < 6)
        {
            switch (item) {
                case 0:
                {
                    strValue = _member.fullName;
                }
                    break;
                case 1:
                {
                    strValue = _member.nickname;
                }
                    break;
                case 2:
                {
                    strValue = _member.phoneNo;
                }
                    break;
                case 3:
                {
                    if(!_member.birthDate)
                    {
                        strValue = @"";
                    }
                    else
                    {
                        strValue = [Utility dateToString:_member.birthDate toFormat:@"d MMM yyyy"];
                    }
                }
                    break;
                case 4:
                {
                    strValue = _member.gender;
                }
                    break;
                case 5:
                {
                    NSInteger totalPoint = [RewardPoint getTotalPointWithMemberID:_member.memberID];
                    NSString *strTotalPoint = [Utility formatDecimal:totalPoint withMinFraction:0 andMaxFraction:0];
                    strValue = strTotalPoint;
                }
                    break;
                default:
                    break;
            }
            
            
            UIFont *font = [UIFont systemFontOfSize:15.0];
            CGSize labelSize = [self suggestedSizeWithFont:font size:CGSizeMake(colVwMemberDetail.frame.size.width - 16 - 16 - 59.5 - 8, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:strValue];
            
            
            float height = labelSize.height+14*2;
            size = CGSizeMake(colVwMemberDetail.frame.size.width,height);
        }
        else if(item > 6)
        {
            Address *address = _addressList[item - 1 - 6];
            strValue = [Address getFullAddress:address];
            
            
            UIFont *font = [UIFont systemFontOfSize:15.0];
            CGSize labelSize = [self suggestedSizeWithFont:font size:CGSizeMake(colVwMemberDetail.frame.size.width - 16 - 16 - 59.5 - 8, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:strValue];
            
            
            float height = labelSize.height+14*2;
            size = CGSizeMake(colVwMemberDetail.frame.size.width,height);
        }
        else
        {
            size = CGSizeMake(colVwMemberDetail.frame.size.width,100);
        }
    }
    
    
    return size;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)colVwMemberDetail.collectionViewLayout;
        
        [layout invalidateLayout];
        [colVwMemberDetail reloadData];
    }
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);//top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        reusableview = headerView;
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerPayment" forIndexPath:indexPath];
        
        reusableview = footerview;
    }
    
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
{
    CGSize headerSize = CGSizeMake(collectionView.bounds.size.width, 0);
    return headerSize;
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger item = indexPath.item;
    if(item <= 3)
    {
        CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (item) {
            case 0:
            {
                cell.lblTitle.text = @"ชื่อ:";
                cell.txtValue.tag = 1;
                cell.txtValue.delegate = self;
            }
                break;
            case 1:
            {
                cell.lblTitle.text = @"ชื่อเล่น:";
                cell.txtValue.tag = 2;
                cell.txtValue.delegate = self;
            }
                break;
            case 2:
            {
                cell.lblTitle.text = @"เบอร์โทร:";
                cell.txtValue.tag = 3;
                cell.txtValue.delegate = self;
            }
                break;
            case 3:
            {
                cell.lblTitle.text = @"วันเกิด:";
                cell.txtValue.tag = 4;
                cell.txtValue.delegate = self;
                
                
                cell.txtValue.inputView = dtPicker;
                cell.txtValue.delegate = self;
                cell.txtValue.text = @"";
            }
                break;
            default:
                break;
        }
        
        return cell;
    }
    else if(item == 4)
    {
        CustomTableViewCellLabelSegment *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelSegment];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.lblTitle.text = @"เพศ:";
        [cell.segConGender addTarget:self action:@selector(segmentedControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
        cell.segConGender.tag = 5;
        return cell;
        
        
    }
    
    
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
    
}

- (void)confirmRegister:(id)sender
{
    [self.view endEditing:YES];
    if(![self validateMemberRegister])
    {
        return;
    }
    
    
    
    
    //insert
    Member *member = [[Member alloc]initWithFullName:_editingMember.fullName nickname:_editingMember.nickname phoneNo:_editingMember.phoneNo birthDate:_editingMember.birthDate gender:_editingMember.gender memberDate:[Utility currentDateTime]];
    [Member addObject:member];
    [self.homeModel insertItems:dbMember withData:member actionScreen:@"Insert member in receipt screen"];
    [self showAlert:@"" message:@"สมัครสมาชิกสำเร็จ"];
    [self closeMemberRegisterBoxAndClearData];
    
}

- (void)cancelRegister:(id)sender
{
    [self closeMemberRegisterBoxAndClearData];
}

- (void)addAddress:(id)sender
{
    [self closeMemberRegisterBoxAndClearData];
    
    if(!_member)
    {
        [self showAlert:@"" message:@"กรุณากรอกเลขสมาชิกเพื่อเพิ่มทีอยู่"];
        return;
    }
    // grab the view controller we want to show
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddressViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"AddressViewController"];
    controller.preferredContentSize = CGSizeMake(300, 44*10+44*2+89+58);//count item+count header
    controller.memberID = _member.memberID;
    controller.vc = self;
    controller.firstAddressFlag = [_addressList count]==0;
    controller.editAddress = nil;
    controller.addressList = _addressList;
    
    
    
    // present the controller
    // on iPad, this will be a Popover
    // on iPhone, this will be an action sheet
    controller.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:controller animated:YES completion:nil];
    
    // configure the Popover presentation controller
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.delegate = self;
    
    
    
    // in case we don't have a bar button as reference
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:6 inSection:0];
    CustomCollectionViewCellAddAddress *cell = (CustomCollectionViewCellAddAddress *)[colVwMemberDetail cellForItemAtIndexPath:indexPath];
    popController.sourceView = cell.btnAddAddress;
    popController.sourceRect = cell.btnAddAddress.bounds;
}

- (BOOL)validateMemberRegister
{
    //require phone on and name
    if([Utility isStringEmpty:_editingMember.fullName])
    {
        UITextField *textField = (UITextField *)[self.view viewWithTag:1];
        [self showAlert:@"" message:@"กรุณาใส่ชื่อ"];
        [textField becomeFirstResponder];
        return NO;
    }
    if([Utility isStringEmpty:_editingMember.phoneNo])
    {
        UITextField *textField = (UITextField *)[self.view viewWithTag:3];
        [self showAlert:@"" message:@"กรุณาใส่หมายเลขโทรศัพท์"];
        [textField becomeFirstResponder];
        return NO;
    }
    
    
    
    //check phoneno exist
    Member *member = [Member getMemberWithPhoneNo:_editingMember.phoneNo];
    if(member)
    {
        [self showAlert:@"" message:@"สมาชิกนี้มีอยู่แล้ว"];
        return NO;
    }
    return YES;
}

- (void)closeMemberRegisterBoxAndClearData
{
    [tbvMemberRegister removeFromSuperview];
}

- (void)closeMemberRegisterBox
{
    [tbvMemberRegister removeFromSuperview];
}

- (void)reloadMemberDetail
{
    NSString *phoneNo = [Utility trimString:txtMemberNo.text];
    _member = [Member getMemberWithPhoneNo:phoneNo];
    if(_member)
    {
        _addressList = [Address getAddressListWithMemberID:_member.memberID];
        _memberDetailNoOfItem = 6 + 1 + [_addressList count];//1=เพิ่มที่อยู่
    }
    else
    {
        _memberDetailNoOfItem = 6;
    }
    
    [colVwMemberDetail reloadData];
}

- (void)updateMemberInReceipt
{
    ///update receipt when input/delete member
    if(_member)
    {
        //update receipt
        if(receipt.idInserted)
        {
            receipt.memberID = _member.memberID;
            receipt.modifiedUser = [Utility modifiedUser];
            receipt.modifiedDate = [Utility currentDateTime];
            [self.homeModel updateItems:dbReceipt withData:receipt actionScreen:@"Update receipt when put member code in receipt screen"];
        }
        else
        {
            txtMemberNo.text = @"";
            [self reloadMemberDetail];
            [self showAlertAndCallPushSync:@"" message:@"ไม่สามารถใช้รหัสสมาชิกได้ กรุณาลองใหม่อีกครั้ง"];
            return;
        }
    }
    else
    {
        //update receipt
        if(receipt.idInserted)
        {
            receipt.memberID = 0;
            receipt.modifiedUser = [Utility modifiedUser];
            receipt.modifiedDate = [Utility currentDateTime];
            [self.homeModel updateItems:dbReceipt withData:receipt actionScreen:@"Update receipt when no member code valid or clear member code in receipt screen"];
        }
        else
        {
            [self showAlertAndCallPushSync:@"" message:@"ไม่สามารถลบการใช้รหัสสมาชิกได้ กรุณาลองใหม่อีกครั้ง"];
            return;
        }
    }
}

- (IBAction)printTaxInvoice:(id)sender
{
    _print = 1;
    [self viewTaxInvoice];
}

-(void)viewTaxInvoice
{
    [self loadingOverlayView];
    
    
    //prepare data to print main
    NSString *companyName = [Setting getSettingValueWithKeyName:@"companyName"];
    NSString *companyAddress = [Setting getSettingValueWithKeyName:@"companyAddress"];
    NSString *phoneNo = [Setting getSettingValueWithKeyName:@"phoneNo"];
    NSString *taxID = [Setting getSettingValueWithKeyName:@"taxID"];
    
    
    Member *member = [Member getMember:receipt.memberID];
    Address *address = [Address getTaxAddressWithMemberID:member.memberID];
    NSString *customerName = address.taxCustomerName;
    NSString *customerAddress = [Address getFullAddress:address];
    NSString *customerPhoneNo = address.taxPhoneNo;
    NSString *customerTaxID = address.taxID;
    customerName = !customerName?@"":customerName;
    customerAddress = !customerAddress?@"":customerAddress;
    customerPhoneNo = !customerPhoneNo?@"":customerPhoneNo;
    customerTaxID = !customerTaxID?@"":customerTaxID;
    
    
    CustomerTable *customerTable = [CustomerTable getCustomerTable:receipt.customerTableID];
    NSString *customerType = customerTable.tableName;
    NSString *cashierName = [UserAccount getFirstNameWithFullName:[UserAccount getCurrentUserAccount].fullName];
    NSString *receiptNoTax = [ReceiptNoTax makeFormatedReceiptNoTaxWithReceiptNoTaxID:receipt.receiptNoTaxID];
    NSString *receiptTime = [Utility dateToString:receipt.receiptDate toFormat:@"yyyy-MM-dd"];
    NSString *memberCode = member?member.phoneNo:@"-";
    NSInteger totalPoint = member?[RewardPoint getTotalPointWithMemberID:member.memberID]:0;
    NSString *strTotalPoint = [Utility formatDecimal:totalPoint withMinFraction:0 andMaxFraction:0];
    NSString *thankYou = [Setting getSettingValueWithKeyName:@"thankYou"];
    
    
    
    //items
    NSMutableArray *items = [[NSMutableArray alloc]init];
    NSMutableArray *printOrderTakingList = [[NSMutableArray alloc]init];
    NSMutableArray *status0OrderTakingList = [OrderTaking getOrderTakingListWithStatus:0 orderTakingList:orderTakingList];
    NSMutableArray *status6OrderTakingList = [OrderTaking getOrderTakingListWithStatus:6 orderTakingList:orderTakingList];
    [printOrderTakingList addObjectsFromArray:status0OrderTakingList];
    [printOrderTakingList addObjectsFromArray:status6OrderTakingList];
    for(OrderTaking *item in printOrderTakingList)
    {
        NSMutableDictionary *dicItem = [[NSMutableDictionary alloc]init];
        NSString *strQuantity = [Utility formatDecimal:item.quantity withMinFraction:0 andMaxFraction:0];
        
        Menu *menu = [Menu getMenu:item.menuID];
        NSString *strTotalPricePerItem = [Utility formatDecimal:item.specialPrice*item.quantity withMinFraction:0 andMaxFraction:0];
        NSString *removeTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:item.orderTakingID noteType:-1];
        NSString *addTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:item.orderTakingID noteType:1];
        
        
        
        
        //promotion item
        NSString *strPro;
        if(item.specialPrice == item.price)
        {
            strPro = @"";
        }
        else
        {
            strPro = @"P";
        }
        
        
        //take away
        NSString *strTakeAway = @"";
        if(item.takeAway)
        {
            strTakeAway = @"ใส่ห่อ";
        }
        
        [dicItem setValue:strQuantity forKey:@"quantity"];
        [dicItem setValue:strTakeAway forKey:@"takeAway"];
        [dicItem setValue:menu.titleThai forKey:@"menu"];
        [dicItem setValue:removeTypeNote forKey:@"removeTypeNote"];
        [dicItem setValue:addTypeNote forKey:@"addTypeNote"];
        [dicItem setValue:strPro forKey:@"pro"];
        [dicItem setValue:strTotalPricePerItem forKey:@"totalPricePerItem"];
        [items addObject:dicItem];
    }
    
    
    //pay by cash
    NSString *strCashReceive = [Utility formatDecimal:receipt.cashReceive withMinFraction:2 andMaxFraction:2];
    NSString *strCashChanges = [Utility formatDecimal:receipt.cashReceive-receipt.cashAmount withMinFraction:2 andMaxFraction:2];
    
    
    
    //pay by credit card
    NSString *strCreditCardType = [Receipt getStringCreditCardType:receipt];
    NSString *strLast4Digits = receipt.creditCardNo;
    NSString *strCreditCardAmount = [Utility formatDecimal:receipt.creditCardAmount withMinFraction:2 andMaxFraction:2];
    
    
    
    //pay by transfer
    NSString *strTransferDate = [Utility dateToString:receipt.transferDate toFormat:@"d MMM yyyy HH:mm"];
    NSString *strTransferAmount = [Utility formatDecimal:receipt.transferAmount withMinFraction:2 andMaxFraction:2];
    
    //create html invoice
    InvoiceComposer *invoiceComposer = [[InvoiceComposer alloc]init];
    NSString *invoiceHtml = [invoiceComposer renderInvoiceWithCompanyName:companyName companyAddress:companyAddress phoneNo:phoneNo taxID:taxID customerName:customerName customerAddress:customerAddress customerPhoneNo:customerPhoneNo customerTaxID:customerTaxID customerType:customerType cashierName:cashierName receiptNo:receiptNoTax receiptTime:receiptTime totalQuantity:strTotalQuantity subTotalAmount:strSubTotalAmount discountAmount:strDiscountAmount afterDiscountAmount:strAfterDiscountAmount serviceChargeAmount:strServiceCharge vatAmount:strVat roundingAmount:strRounding totalAmount:strTotalAmount cashReceive:strCashReceive cashChanges:strCashChanges creditCardType:strCreditCardType last4Digits:strLast4Digits creditCardAmount:strCreditCardAmount transferDate:receipt transferAmount:strTransferAmount memberCode:memberCode totalPoint:strTotalPoint thankYou:thankYou items:items];
    
    [_htmlContentList removeAllObjects];
    [_htmlContentList addObject:invoiceHtml];
    
    
    
    
    //load into webview in order to calculate height of content to prepare pdf
    [_webview2 loadHTMLString:invoiceHtml baseURL:NULL];
    
    
    [_webview loadHTMLString:invoiceHtml baseURL:NULL];
    
    
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    [super webViewDidFinishLoad:aWebView];
    if(self.receiptKitchenBill)
    {
        self.receiptKitchenBill = 0;
        return;
    }
    
    
    if([aWebView isEqual:_webview2])
    {
        NSString *pdfFileName = [self createPDFfromUIView:aWebView saveToDocumentsWithFileName:@"receipt.pdf"];
        
        
        if(!_print)
        {
            [self removeOverlayViews];
            return;
        }
        else
        {
            _print = 0;
        }
        
        
        
        //convert pdf to image
        NSURL *pdfUrl = [NSURL fileURLWithPath:pdfFileName];
        UIImage *pdfImagePrint = [self pdfToImage:pdfUrl];
        UIImageWriteToSavedPhotosAlbum(pdfImagePrint, nil, nil, nil);
        NSLog(@"pdf fileName: %@",pdfFileName);
        
        
        //        //test remove after finish test
        //        return;
        
        
        
        NSString *printBill = [Setting getSettingValueWithKeyName:@"printBill"];
        if(![printBill integerValue])
        {
            [self removeOverlayViews];
        }
        else
        {
            //print process
            NSString *portName = [Setting getSettingValueWithKeyName:@"printerPortCashier"];
            NSLog(@"portName receipt: %@",portName);
            [self doPrintProcess:pdfImagePrint portName:portName];
        }
    }
}

-(void)doPrintProcess:(UIImage *)image portName:(NSString *)portName
{
    NSData *commands = nil;
    
    ISCBBuilder *builder = [StarIoExt createCommandBuilder:[AppDelegate getEmulation]];
    
    [builder beginDocument];
    
    [builder appendBitmap:image diffusion:NO];
    
    [builder appendCutPaper:SCBCutPaperActionPartialCutWithFeed];
    
    [builder endDocument];
    
    commands = [builder.commands copy];
    
    
    //    NSString *portName     = [AppDelegate getPortName];
    NSString *portSettings = [AppDelegate getPortSettings];
    
    [Communication sendCommands:commands portName:portName portSettings:portSettings timeout:10000 completionHandler:^(BOOL result, NSString *title, NSString *message)
     {     // 10000mS!!!
         if(![message isEqualToString:@"พิมพ์สำเร็จ"])
         {
             
             UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                            message:message
                                                                     preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action)
                                             {
                                                 [self removeOverlayViews];
                                             }];
             
             [alert addAction:defaultAction];
             [self presentViewController:alert animated:YES completion:nil];
         }
         else
         {
             [self removeOverlayViews];
         }
     }];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    [self closeMemberRegisterBoxAndClearData];
    
    
    CGPoint point = [gestureRecognizer locationInView:colVwMemberDetail];
    NSIndexPath * tappedIP = [colVwMemberDetail indexPathForItemAtPoint:point];
    UICollectionViewCell *cell = [colVwMemberDetail cellForItemAtIndexPath:tappedIP];
    NSInteger item = tappedIP.item;
    
    
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:
     [UIAlertAction actionWithTitle:@"แก้ไข"
                              style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
      {
          
          
          
          // grab the view controller we want to show
          UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
          AddressViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"AddressViewController"];
          controller.preferredContentSize = CGSizeMake(300, 44*10+44*2+89+58);
          controller.memberID = _member.memberID;
          controller.vc = self;
          controller.firstAddressFlag = [_addressList count]==0;
          controller.editAddress = _addressList[item - 1 - 6];
          controller.addressList = _addressList;
          
          
          // present the controller
          // on iPad, this will be a Popover
          // on iPhone, this will be an action sheet
          controller.modalPresentationStyle = UIModalPresentationFormSheet;
          [self presentViewController:controller animated:YES completion:nil];
          
          // configure the Popover presentation controller
          UIPopoverPresentationController *popController = [controller popoverPresentationController];
          popController.permittedArrowDirections = UIPopoverArrowDirectionUp;
          
          
          CGRect frame = cell.bounds;
          frame.origin.y = frame.origin.y-15;
          popController.sourceView = cell;
          popController.sourceRect = frame;
          
          
          
      }]];
    [alert addAction:
     [UIAlertAction actionWithTitle:@"ลบ"
                              style:UIAlertActionStyleDestructive
                            handler:^(UIAlertAction *action) {
                                
                                Address *address = _addressList[item - 1 - 6];
                                [Address removeObject:address];
                                [self.homeModel deleteItems:dbAddress withData:address actionScreen:@"Delete address in receipt screen"];
                                [self reloadMemberDetail];
                            }]];
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        [alert setModalPresentationStyle:UIModalPresentationPopover];
        
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        popPresenter.permittedArrowDirections = UIPopoverArrowDirectionUp;
        CGRect frame = cell.bounds;
        frame.origin.y = frame.origin.y-15;
        popPresenter.sourceView = cell;
        popPresenter.sourceRect = frame;
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)segmentedControlValueDidChange:(UISegmentedControl *)segment
{
    [self.view endEditing:YES];
    _editingMember.gender = segment.selectedSegmentIndex == 0?@"M":segment.selectedSegmentIndex == 1?@"F":@"N";
}

- (void)itemsInsertedWithReturnID:(NSString *)strID
{
    if(self.homeModel.propCurrentDBInsert == dbReceiptAndReceiptNoTaxPrint)
    {
        [self removeOverlayViews];
        receipt.receiptNoTaxID = strID;
        NSLog(@"receiptnotaxID : %@",strID);
        if(receipt.memberID != 0)
        {
            Member *member = [Member getMember:receipt.memberID];
            txtMemberNo.text = member.phoneNo;
        }
        [self reloadMemberDetail];
        [self viewTaxInvoice];
    }
}
@end

