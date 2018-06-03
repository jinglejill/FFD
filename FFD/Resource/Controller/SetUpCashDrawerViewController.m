//
//  SetUpCashDrawerViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 29/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SetUpCashDrawerViewController.h"
#import "ShopOpenCloseShiftTimeViewController.h"
#import "CustomCollectionViewCellImageLabelSwitch.h"
#import "CustomCollectionViewCellLabelSwitchButton.h"
#import "CustomCollectionViewCellLabelAndSwitch.h"
#import "CustomCollectionViewCellLabel.h"
#import "CustomCollectionViewCellText.h"
#import "Setting.h"
#import "Utility.h"
#import "RoleTabMenu.h"



@interface SetUpCashDrawerViewController ()
{
    NSInteger _typeTime;
}
@end

@implementation SetUpCashDrawerViewController
static NSString * const reuseIdentifierImageLabelSwitch = @"CustomCollectionViewCellImageLabelSwitch";
static NSString * const reuseIdentifierLabelSwitchButton = @"CustomCollectionViewCellLabelSwitchButton";
static NSString * const reuseIdentifierLabelAndSwitch = @"CustomCollectionViewCellLabelAndSwitch";
static NSString * const reuseIdentifierLabel = @"CustomCollectionViewCellLabel";
static NSString * const reuseIdentifierText = @"CustomCollectionViewCellText";


@synthesize colVwSetUpCashDrawer;
- (IBAction)unwindToSetUpCashDrawer:(UIStoryboardSegue *)segue
{
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField.tag == 21)
    {
        textField.text = [Utility removeComma:textField.text];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag == 21)
    {
        NSString *resultingString = [textField.text stringByReplacingCharactersInRange: range withString: string];
        
        // The user deleting all input is perfectly acceptable.
        if ([resultingString length] == 0) {
            return true;
        }
        
        float holder;
        
        NSScanner *scan = [NSScanner scannerWithString: resultingString];
        
        return [scan scanFloat: &holder] && [scan isAtEnd];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    NSString *strKeyName;
    if(textField.tag == 21)
    {
        strKeyName = @"cashDrawerInitialAmount";
    }
    else if(textField.tag == 22)
    {
        strKeyName = @"openCloseShopEmail";
        
        
        //validate email
        NSArray* emailList = [textField.text componentsSeparatedByString: @","];
        for(NSString *email in emailList)
        {
            if(![Utility isStringEmpty:email] && ![Utility validateEmailWithString:email])
            {
                [self showAlert:@"" message:@"อีเมลล์ไม่ถูกต้อง"];
                return;
            }
        }
    }
    else if(textField.tag == 23)
    {
        strKeyName = @"openCloseShopLine";
    }
    
    
    NSString *strActionScreen = [NSString stringWithFormat:@"update %@ setting in setUpCashDrawer screen",strKeyName];
    Setting *setting = [Setting getSettingWithKeyName:strKeyName];
    setting.value = [Utility trimString:textField.text];
    setting.modifiedUser = [Utility modifiedUser];
    setting.modifiedDate = [Utility currentDateTime];
    [self.homeModel updateItems:dbSetting withData:setting actionScreen:strActionScreen];
}

-(void)loadView
{
    [super loadView];
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    colVwSetUpCashDrawer.delegate = self;
    colVwSetUpCashDrawer.dataSource = self;
    
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierImageLabelSwitch bundle:nil];
        [colVwSetUpCashDrawer registerNib:nib forCellWithReuseIdentifier:reuseIdentifierImageLabelSwitch];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelAndSwitch bundle:nil];
        [colVwSetUpCashDrawer registerNib:nib forCellWithReuseIdentifier:reuseIdentifierLabelAndSwitch];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelSwitchButton bundle:nil];
        [colVwSetUpCashDrawer registerNib:nib forCellWithReuseIdentifier:reuseIdentifierLabelSwitchButton];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabel bundle:nil];
        [colVwSetUpCashDrawer registerNib:nib forCellWithReuseIdentifier:reuseIdentifierLabel];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierText bundle:nil];
        [colVwSetUpCashDrawer registerNib:nib forCellWithReuseIdentifier:reuseIdentifierText];
    }
 
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];
//    [tapGesture setCancelsTouchesInView:NO];
    
    
    colVwSetUpCashDrawer.delaysContentTouches = NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 22;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger item = indexPath.item;
    
    switch (item)
    {
        case 0:
        {
            CustomCollectionViewCellImageLabelSwitch *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierImageLabelSwitch forIndexPath:indexPath];
            cell.contentView.userInteractionEnabled = NO;
            
            
            NSString *strSetting = [Setting getSettingValueWithKeyName:@"openCashDrawer"];
            cell.swtValue.on = [strSetting integerValue];
            cell.swtValue.tag = 1;
            [cell.swtValue addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            
            
            return cell;
        }
            break;
        case 1:
        {
            CustomCollectionViewCellLabel *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierLabel forIndexPath:indexPath];
            
            cell.lblTextLabel.text = @"จำนวนเงินเริ่มต้น (บาท)";
            cell.vwTopBorder.backgroundColor = [UIColor groupTableViewBackgroundColor];
            
            return cell;
        }
            break;
        case 2:
        {
            CustomCollectionViewCellLabelSwitchButton *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierLabelSwitchButton forIndexPath:indexPath];
            cell.contentView.userInteractionEnabled = NO;
            
            
            cell.lblTextLabel.text = @"ตรวจสอบเงินเริ่มต้นก่อนเปิดร้าน";
            cell.lblLeadingConstant.constant = (cell.frame.size.width - 349)/2.0;
            NSInteger checkInitialAmountShopOpen = [[Setting getSettingValueWithKeyName:@"checkInitialAmountShopOpen"] integerValue];
            cell.swtValue.on = checkInitialAmountShopOpen;
            cell.swtValue.tag = 2;
            [cell.swtValue addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            [self setButtonDesign:cell.btnSetting];
            cell.btnSetting.tag = 31;
            cell.btnSetting.enabled = cell.swtValue.on;
            [cell.btnSetting addTarget:self action:@selector(btnSettingTap:) forControlEvents:UIControlEventTouchUpInside];
            cell.vwTopBorder.backgroundColor = [UIColor groupTableViewBackgroundColor];
            
            return cell;
        }
            break;
        case 4:
        {
            CustomCollectionViewCellLabelSwitchButton *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierLabelSwitchButton forIndexPath:indexPath];
            cell.contentView.userInteractionEnabled = NO;
            
            
            cell.lblTextLabel.text = @"ตรวจสอบเงินคงเหลือก่อนปิดร้าน";
            cell.lblLeadingConstant.constant = (cell.frame.size.width - 349)/2.0;
            NSInteger checkInitialAmountShopClose = [[Setting getSettingValueWithKeyName:@"checkInitialAmountShopClose"] integerValue];
            cell.swtValue.on = checkInitialAmountShopClose;
            cell.swtValue.tag = 3;
            [cell.swtValue addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            [self setButtonDesign:cell.btnSetting];
            cell.btnSetting.tag = 32;
            cell.btnSetting.enabled = cell.swtValue.on;
            [cell.btnSetting addTarget:self action:@selector(btnSettingTap:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
            break;
        case 6:
        {
            CustomCollectionViewCellLabelSwitchButton *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierLabelSwitchButton forIndexPath:indexPath];
            cell.contentView.userInteractionEnabled = NO;
            
            
            cell.lblTextLabel.text = @"ตรวจสอบเงินระหว่างกะ";
            cell.lblLeadingConstant.constant = (cell.frame.size.width - 349)/2.0;
            NSInteger checkMoneyShift = [[Setting getSettingValueWithKeyName:@"checkMoneyShift"] integerValue];
            cell.swtValue.on = checkMoneyShift;
            cell.swtValue.tag = 4;
            [cell.swtValue addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            [self setButtonDesign:cell.btnSetting];
            cell.btnSetting.tag = 33;
            cell.btnSetting.enabled = cell.swtValue.on;
            [cell.btnSetting addTarget:self action:@selector(btnSettingTap:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
            break;
        case 3:
        {
            CustomCollectionViewCellText *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierText forIndexPath:indexPath];
            cell.contentView.userInteractionEnabled = NO;
            
            
            cell.txtLeadingConstant.constant = 16;
            cell.txtTrailingConstant.constant = 16;
            float cashDrawerInitialAmount = [[Setting getSettingValueWithKeyName:@"cashDrawerInitialAmount"] floatValue];
            cell.txtText.tag = 21;
            cell.txtText.delegate = self;
            cell.txtText.textAlignment  = NSTextAlignmentCenter;
            cell.txtText.keyboardType = UIKeyboardTypeDecimalPad;
            cell.txtText.placeholder = @"ใส่จำนวนเงิน";
            cell.txtText.text = [Utility formatDecimal:cashDrawerInitialAmount withMinFraction:0 andMaxFraction:2];
            cell.txtHeightConstant.constant = 45;
            
            return cell;
        }
            break;
        case 5:
        {
            CustomCollectionViewCellLabel *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierLabel forIndexPath:indexPath];
            cell.lblTextLabel.text = @"";
            return cell;
        }
        case 7:
        {
            CustomCollectionViewCellLabel *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierLabel forIndexPath:indexPath];
            
            cell.lblTextLabel.text = @"กำหนดสิทธิ์ผู้ใช้ในการรับจ่ายเงิน";
            cell.vwTopBorder.backgroundColor = [UIColor groupTableViewBackgroundColor];
            
            return cell;
        }
            break;
        case 8:
        {
            CustomCollectionViewCellLabel *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierLabel forIndexPath:indexPath];
            
            cell.lblTextLabel.text = @"แจ้งเตือนการเปิดปิดร้านอัตโนมัติ";
            cell.vwTopBorder.backgroundColor = [UIColor groupTableViewBackgroundColor];
            
            return cell;
        }
            break;
        case 9:
        {
            CustomCollectionViewCellLabelAndSwitch *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierLabelAndSwitch forIndexPath:indexPath];
            cell.contentView.userInteractionEnabled = NO;
            
            
            cell.lblTextLabel.text = @"เจ้าของร้าน";
            cell.lblLeadingConstant.constant = (cell.frame.size.width - 291)/2.0;
            NSInteger settingValue = [[Setting getSettingValueWithKeyName:@"allowMoneyOwner"] integerValue];
            cell.swtValue.on = settingValue;
            cell.swtValue.tag = 5;
            [cell.swtValue addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            
            return cell;
        }
            break;
        case 11:
        {
            CustomCollectionViewCellLabelAndSwitch *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierLabelAndSwitch forIndexPath:indexPath];
            cell.contentView.userInteractionEnabled = NO;
            
            
            cell.lblTextLabel.text = @"ผู้จัดการร้าน";
            cell.lblLeadingConstant.constant = (cell.frame.size.width - 291)/2.0;
            NSInteger settingValue = [[Setting getSettingValueWithKeyName:@"allowMoneyManager"] integerValue];
            cell.swtValue.on = settingValue;
            cell.swtValue.tag = 6;
            [cell.swtValue addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            
            return cell;
        }
            break;
        case 13:
        {
            CustomCollectionViewCellLabelAndSwitch *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierLabelAndSwitch forIndexPath:indexPath];
            cell.contentView.userInteractionEnabled = NO;
            
            
            cell.lblTextLabel.text = @"พนักงานแคชเชียร์";
            cell.lblLeadingConstant.constant = (cell.frame.size.width - 291)/2.0;
            NSInteger settingValue = [[Setting getSettingValueWithKeyName:@"allowMoneyCashier"] integerValue];
            cell.swtValue.on = settingValue;
            cell.swtValue.tag = 7;
            [cell.swtValue addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];

            return cell;
        }
            break;
        case 15:
        {
            CustomCollectionViewCellLabelAndSwitch *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierLabelAndSwitch forIndexPath:indexPath];
            cell.contentView.userInteractionEnabled = NO;
            
            
            cell.lblTextLabel.text = @"พนักงานทั่วไป";
            cell.lblLeadingConstant.constant = (cell.frame.size.width - 291)/2.0;
            NSInteger settingValue = [[Setting getSettingValueWithKeyName:@"allowMoneyOther"] integerValue];
            cell.swtValue.on = settingValue;
            cell.swtValue.tag = 8;
            [cell.swtValue addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            
            return cell;
        }
            break;
        case 10:
        {
            CustomCollectionViewCellLabelAndSwitch *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierLabelAndSwitch forIndexPath:indexPath];
            cell.contentView.userInteractionEnabled = NO;
            
            
            cell.lblTextLabel.text = @"อีเมลล์";
            cell.lblLeadingConstant.constant = (cell.frame.size.width - 349)/2.0;
            NSInteger settingValue = [[Setting getSettingValueWithKeyName:@"notiOpenCloseShopEmail"] integerValue];
            cell.swtValue.on = settingValue;
            cell.swtValue.tag = 9;
            [cell.swtValue addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            
            return cell;
        }
            break;
        case 14:
        {
            CustomCollectionViewCellLabelAndSwitch *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierLabelAndSwitch forIndexPath:indexPath];
            cell.contentView.userInteractionEnabled = NO;
            
            
            cell.lblTextLabel.text = @"Line";
            cell.lblLeadingConstant.constant = (cell.frame.size.width - 349)/2.0;
            NSInteger settingValue = [[Setting getSettingValueWithKeyName:@"notiOpenCloseShopLine"] integerValue];
            cell.swtValue.on = settingValue;
            cell.swtValue.tag = 10;
            [cell.swtValue addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            
            return cell;
        }
            break;
        case 12:
        {
            CustomCollectionViewCellText *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierText forIndexPath:indexPath];
            cell.contentView.userInteractionEnabled = NO;
            
            cell.txtLeadingConstant.constant = 16;
            cell.txtTrailingConstant.constant = 16;
            NSString *strOpenCloseShopEmail = [Setting getSettingValueWithKeyName:@"openCloseShopEmail"];
            cell.txtText.tag = 22;
            cell.txtText.delegate = self;
            cell.txtText.textAlignment  = NSTextAlignmentCenter;
            cell.txtText.keyboardType = UIKeyboardTypeDefault;
            cell.txtText.placeholder = @"ใส่อีเมลล์";
            cell.txtText.text = strOpenCloseShopEmail;
            NSInteger notiOpenCloseShopEmail = [[Setting getSettingValueWithKeyName:@"notiOpenCloseShopEmail"] integerValue];
            cell.txtText.enabled = notiOpenCloseShopEmail;
            cell.txtHeightConstant.constant = 45;
            
            return cell;
        }
            break;
        case 16:
        {
            CustomCollectionViewCellText *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierText forIndexPath:indexPath];
            cell.contentView.userInteractionEnabled = NO;
            
            cell.txtLeadingConstant.constant = 16;
            cell.txtTrailingConstant.constant = 16;
            NSString *strOpenCloseShopLine = [Setting getSettingValueWithKeyName:@"openCloseShopLine"];
            cell.txtText.tag = 23;
            cell.txtText.delegate = self;
            cell.txtText.textAlignment  = NSTextAlignmentCenter;
            cell.txtText.keyboardType = UIKeyboardTypeDefault;
            cell.txtText.placeholder = @"ใส่ Line ID";
            cell.txtText.text = strOpenCloseShopLine;
            NSInteger notiOpenCloseShopLine = [[Setting getSettingValueWithKeyName:@"notiOpenCloseShopLine"] integerValue];
            cell.txtText.enabled = notiOpenCloseShopLine;
            cell.txtHeightConstant.constant = 45;
            
            return cell;
        }
            break;
        case 17:
        {
            CustomCollectionViewCellLabel *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierLabel forIndexPath:indexPath];
            
            cell.lblTextLabel.text = @"วิธีการจ่ายเงิน (บาท)";
            cell.vwTopBorder.backgroundColor = [UIColor groupTableViewBackgroundColor];
            
            return cell;
        }
            break;
        case 18:
        {
            CustomCollectionViewCellLabelAndSwitch *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierLabelAndSwitch forIndexPath:indexPath];
            cell.contentView.userInteractionEnabled = NO;
            
            
            cell.lblTextLabel.text = @"เงินสด";
            cell.lblLeadingConstant.constant = (cell.frame.size.width - 291)/2.0;
            NSInteger settingValue = [[Setting getSettingValueWithKeyName:@"paymentMethodCash"] integerValue];
            cell.swtValue.on = settingValue;
            cell.swtValue.tag = 11;
            [cell.swtValue addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            
            return cell;
        }
            break;
        case 19:
        {
            CustomCollectionViewCellLabelAndSwitch *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierLabelAndSwitch forIndexPath:indexPath];
            cell.contentView.userInteractionEnabled = NO;
            
            
            cell.lblTextLabel.text = @"บัตรเครดิต/เดบิต";
            cell.lblLeadingConstant.constant = (cell.frame.size.width - 349)/2.0;
            NSInteger settingValue = [[Setting getSettingValueWithKeyName:@"paymentMethodCredit"] integerValue];
            cell.swtValue.on = settingValue;
            cell.swtValue.tag = 12;
            [cell.swtValue addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            
            return cell;
        }
            break;
        case 20:
        {
            CustomCollectionViewCellLabelAndSwitch *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierLabelAndSwitch forIndexPath:indexPath];
            cell.contentView.userInteractionEnabled = NO;
            
            
            cell.lblTextLabel.text = @"โอนเงิน";
            cell.lblLeadingConstant.constant = (cell.frame.size.width - 291)/2.0;
            NSInteger settingValue = [[Setting getSettingValueWithKeyName:@"paymentMethodTransfer"] integerValue];
            cell.swtValue.on = settingValue;
            cell.swtValue.tag = 13;
            [cell.swtValue addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            
            return cell;
        }
            break;
        case 21:
        {
            CustomCollectionViewCellLabelAndSwitch *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierLabelAndSwitch forIndexPath:indexPath];
            cell.contentView.userInteractionEnabled = NO;
            
            
            cell.lblTextLabel.text = @"E-Walllet/QR Code";
            cell.lblLeadingConstant.constant = (cell.frame.size.width - 349)/2.0;
            NSInteger settingValue = [[Setting getSettingValueWithKeyName:@"paymentMethodEWallet"] integerValue];
            cell.swtValue.on = settingValue;
            cell.swtValue.tag = 14;
            [cell.swtValue addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            
            return cell;
        }
            break;
        default:
            break;
    }

    
    return nil;
}

#pragma mark <UICollectionViewDelegate>


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    switch (indexPath.item)
    {
        case 0:
        {
            return CGSizeMake(collectionView.frame.size.width, 80);
        }
        break;
        case 1 ... 16:
        case 18 ... 21:
        {
            return CGSizeMake(collectionView.frame.size.width/2, 55);
        }
            break;
        case 17:
        {
            return CGSizeMake(collectionView.frame.size.width, 50);
        }
            break;
        default:
            break;
    }
    
    return CGSizeMake(collectionView.frame.size.width, 44);
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)colVwSetUpCashDrawer.collectionViewLayout;
        
        [layout invalidateLayout];
        [colVwSetUpCashDrawer reloadData];
    }
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
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

- (IBAction)backToSetting:(id)sender
{
    [self.view endEditing:YES];
    [self performSegueWithIdentifier:@"segUnwindToSetting" sender:self];
}

- (void)switchChanged:(id)sender
{
    UISwitch *swtValue = sender;
    NSString *strKeyName;;
    switch (swtValue.tag)
    {
        case 1:
            strKeyName = @"openCashDrawer";
            break;
        case 2:
        {
            strKeyName = @"checkInitialAmountShopOpen";
            UIButton *btnSetting = [self.view viewWithTag:31];
            btnSetting.enabled = swtValue.on;
        }
            break;
        case 3:
        {
            strKeyName = @"checkInitialAmountShopClose";
            UIButton *btnSetting = [self.view viewWithTag:32];
            btnSetting.enabled = swtValue.on;
        }
            break;
        case 4:
        {
            strKeyName = @"checkMoneyShift";
            UIButton *btnSetting = [self.view viewWithTag:33];
            btnSetting.enabled = swtValue.on;
        }
            break;
        case 5:
        {
            strKeyName = @"allowMoneyOwner";
            //set role to access/not access money process
            //tabmenu from 7-13, roleID = 1
            if(swtValue.on)
            {
                NSMutableArray *roleTabMenuList = [RoleTabMenu createRoleTabMenuListWithRoleID:1 tabMenuType:2];
                [self.homeModel insertItems:dbRoleTabMenuList withData:roleTabMenuList actionScreen:@"insert roleTabMenuList in setUpCashDrawer screen"];
            }
            else
            {
                NSMutableArray *roleTabMenuList = [RoleTabMenu getRoleTabMenuListWithRoleID:1 tabMenuType:2];
                [RoleTabMenu removeList:roleTabMenuList];
                [self.homeModel deleteItems:dbRoleTabMenuList withData:roleTabMenuList actionScreen:@"delete roleTabMenuList in setUpCashDrawer screen"];
            }
        }
            break;
        case 6:
        {
            strKeyName = @"allowMoneyManager";
            //set role to access/not access money process
            //tabmenu from 7-13, roleID = 2
            if(swtValue.on)
            {
                NSMutableArray *roleTabMenuList = [RoleTabMenu createRoleTabMenuListWithRoleID:2 tabMenuType:2];
                [self.homeModel insertItems:dbRoleTabMenuList withData:roleTabMenuList actionScreen:@"insert roleTabMenuList in setUpCashDrawer screen"];
            }
            else
            {
                NSMutableArray *roleTabMenuList = [RoleTabMenu getRoleTabMenuListWithRoleID:2 tabMenuType:2];
                [RoleTabMenu removeList:roleTabMenuList];
                [self.homeModel deleteItems:dbRoleTabMenuList withData:roleTabMenuList actionScreen:@"delete roleTabMenuList in setUpCashDrawer screen"];
            }
        }
            break;
        case 7:
        {
            strKeyName = @"allowMoneyCashier";
            //set role to access/not access money process
            //tabmenu from 7-13, roleID = 3
            if(swtValue.on)
            {
                NSMutableArray *roleTabMenuList = [RoleTabMenu createRoleTabMenuListWithRoleID:3 tabMenuType:2];
                [self.homeModel insertItems:dbRoleTabMenuList withData:roleTabMenuList actionScreen:@"insert roleTabMenuList in setUpCashDrawer screen"];
            }
            else
            {
                NSMutableArray *roleTabMenuList = [RoleTabMenu getRoleTabMenuListWithRoleID:3 tabMenuType:2];
                [RoleTabMenu removeList:roleTabMenuList];
                [self.homeModel deleteItems:dbRoleTabMenuList withData:roleTabMenuList actionScreen:@"delete roleTabMenuList in setUpCashDrawer screen"];
            }
        }
            break;
        case 8:
        {
            strKeyName = @"allowMoneyOther";
            //set role to access/not access money process
            //tabmenu from 7-13, roleID = 4
            if(swtValue.on)
            {
                NSMutableArray *roleTabMenuList = [RoleTabMenu createRoleTabMenuListWithRoleID:4 tabMenuType:2];
                [self.homeModel insertItems:dbRoleTabMenuList withData:roleTabMenuList actionScreen:@"insert roleTabMenuList in setUpCashDrawer screen"];
            }
            else
            {
                NSMutableArray *roleTabMenuList = [RoleTabMenu getRoleTabMenuListWithRoleID:4 tabMenuType:2];
                [RoleTabMenu removeList:roleTabMenuList];
                [self.homeModel deleteItems:dbRoleTabMenuList withData:roleTabMenuList actionScreen:@"delete roleTabMenuList in setUpCashDrawer screen"];
            }
        }
            break;
        case 9:
        {
            strKeyName = @"notiOpenCloseShopEmail";
            UITextField *txtValue = [self.view viewWithTag:22];
            txtValue.enabled = swtValue.on;
        }
            break;
        case 10:
        {
            strKeyName = @"notiOpenCloseShopLine";
            UITextField *txtValue = [self.view viewWithTag:23];
            txtValue.enabled = swtValue.on;
        }
            break;
        case 11:
            strKeyName = @"paymentMethodCash";
            break;
        case 12:
            strKeyName = @"paymentMethodCredit";
            break;
        case 13:
            strKeyName = @"paymentMethodTransfer";
            break;
        case 14:
            strKeyName = @"paymentMethodEWallet";
            break;
        default:
            break;
    }
    NSString *strActionScreen = [NSString stringWithFormat:@"update %@ setting in setUpCashDrawer screen",strKeyName];
    Setting *setting = [Setting getSettingWithKeyName:strKeyName];
    setting.value = swtValue.on?@"1":@"0";
    setting.modifiedUser = [Utility modifiedUser];
    setting.modifiedDate = [Utility currentDateTime];
    [self.homeModel updateItems:dbSetting withData:setting actionScreen:strActionScreen];
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    
    // return YES if the Popover should be dismissed
    // return NO if the Popover should not be dismissed
    return NO;
}

- (void)btnSettingTap:(id)sender
{
    UIButton *btnValue = sender;
    float height = 0;
    switch (btnValue.tag)
    {
        case 31:
        {
            _typeTime = 1;
            height = 44*1+58+60+60;
        }
            break;
        case 32:
        {
            _typeTime = 2;
            height = 44*1+58+60+60;
        }
            break;
        case 33:
        {
            _typeTime = 3;
            height = 44*9+58;
        }
            break;
        default:
            break;
    }
    
    
    // grab the view controller we want to show
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ShopOpenCloseShiftTimeViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ShopOpenCloseShiftTimeViewController"];
    controller.preferredContentSize = CGSizeMake(300, height);
    controller.type = _typeTime;
    
    
    
    // present the controller
    // on iPad, this will be a Popover
    // on iPhone, this will be an action sheet
    controller.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:controller animated:YES completion:nil];
    
    // configure the Popover presentation controller
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.delegate = self;
    
    
    
    CGRect frame = btnValue.frame;
    frame.origin.y = frame.origin.y-15;
    popController.sourceView = btnValue;
    popController.sourceRect = frame;
    
}
@end
