//
//  SetUpPrinterViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 24/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SetUpPrinterViewController.h"
#import "SearchPortViewController.h"
#import "SelectPrinterViewController.h"
#import "CustomCollectionViewCellPrinter.h"
#import "CustomCollectionViewCellLabel.h"
#import "CustomCollectionViewCellLabelAndSwitch.h"
#import "CustomCollectionViewCellLabelSwitchText.h"
#import "CustomCollectionViewCellButton.h"
#import "Printer.h"
#import "Setting.h"
#import <StarIO/SMPort.h>
#import "AppDelegate.h"



@interface SetUpPrinterViewController ()
{
    NSArray *_printerCodeList;
    Printer *_selectedPrinter;
    NSMutableArray *_statusCellArray;
    NSMutableArray *_firmwareInfoCellArray;
    UITextField *_txtFoodCheckList;
    UIButton *_btnTrashFoodCheckList;
}
@end

@implementation SetUpPrinterViewController
static NSString * const reuseIdentifierPrinter = @"CustomCollectionViewCellPrinter";
static NSString * const reuseIdentifierLabel = @"CustomCollectionViewCellLabel";
static NSString * const reuseIdentifierLabelAndSwitch = @"CustomCollectionViewCellLabelAndSwitch";
static NSString * const reuseIdentifierLabelSwitchText = @"CustomCollectionViewCellLabelSwitchText";
static NSString * const reuseIdentifierButton = @"CustomCollectionViewCellButton";


@synthesize colVwSetUpPrinter;
@synthesize colVwStatus;
@synthesize swPrinterOn;
@synthesize btnRefreshStatus;

- (IBAction)unwindToSetUpPrinter:(UIStoryboardSegue *)selectPrinter
{
    SearchPortViewController *vc = selectPrinter.sourceViewController;
    if(vc.selectPrinter)
    {
        _selectedPrinter.printerStatus = 1;
        [colVwSetUpPrinter reloadData];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if([textField isEqual:_txtFoodCheckList])
    {
        [textField resignFirstResponder];
        
        
        // grab the view controller we want to show
        NSMutableArray *printerList = [Printer getPrinterList];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SelectPrinterViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"SelectPrinterViewController"];
        controller.preferredContentSize = CGSizeMake(300, 44*[printerList count]);
        controller.vc = self;
        
        
        
        // present the controller
        // on iPad, this will be a Popover
        // on iPhone, this will be an action sheet
        controller.modalPresentationStyle = UIModalPresentationPopover;
        [self presentViewController:controller animated:YES completion:nil];
        
        // configure the Popover presentation controller
        UIPopoverPresentationController *popController = [controller popoverPresentationController];
        popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        popController.delegate = self;
        
        
        
        CGRect frame = textField.frame;
        frame.origin.y = frame.origin.y-15;
        popController.sourceView = textField;
        popController.sourceRect = frame;

    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([textField isEqual:_txtFoodCheckList])
    {
        Setting *setting = [Setting getSettingWithKeyName:@"foodCheckList"];
        setting.value = textField.text;
        setting.modifiedUser = [Utility modifiedUser];
        setting.modifiedDate = [Utility currentDateTime];
        [self.homeModel updateItems:dbSetting withData:setting actionScreen:@"update foodCheckList setting in setUpPrinter screen "];
    }
}

-(void)loadView
{
    [super loadView];
    _printerCodeList = @[@"Kitchen",@"Kitchen2",@"Drinks",@"Cashier"];
    
    
    NSString *strPrintBill = [Setting getSettingValueWithKeyName:@"printBill"];
    swPrinterOn.on = [strPrintBill isEqualToString:@"1"];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    colVwSetUpPrinter.delegate = self;
    colVwSetUpPrinter.dataSource = self;
    
    colVwStatus.delegate = self;
    colVwStatus.dataSource = self;
    
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierPrinter bundle:nil];
        [colVwSetUpPrinter registerNib:nib forCellWithReuseIdentifier:reuseIdentifierPrinter];
    }

    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabel bundle:nil];
        [colVwStatus registerNib:nib forCellWithReuseIdentifier:reuseIdentifierLabel];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelAndSwitch bundle:nil];
        [colVwStatus registerNib:nib forCellWithReuseIdentifier:reuseIdentifierLabelAndSwitch];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelSwitchText bundle:nil];
        [colVwStatus registerNib:nib forCellWithReuseIdentifier:reuseIdentifierLabelSwitchText];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierButton bundle:nil];
        [colVwStatus registerNib:nib forCellWithReuseIdentifier:reuseIdentifierButton];
    }
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    for(int i=0; i<[_printerCodeList count]; i++)
    {
        Printer *printer = [Printer getPrinterWithCode:_printerCodeList[i]];
        printer.printerStatus = 0;
    }
    
    
    
//    [self checkPrinterStatus];
    [colVwSetUpPrinter reloadData];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if([collectionView isEqual:colVwSetUpPrinter])
    {
        return  [_printerCodeList count]>0;
    }
    if([collectionView isEqual:colVwStatus])
    {
        return 1;
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if([collectionView isEqual:colVwSetUpPrinter])
    {
        return [_printerCodeList count];
    }
    else if([collectionView isEqual:colVwStatus])
    {
        return 6;
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger item = indexPath.item;
    
    if([collectionView isEqual:colVwSetUpPrinter])
    {
        CustomCollectionViewCellPrinter *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierPrinter forIndexPath:indexPath];
        cell.contentView.userInteractionEnabled = NO;
        
        
        Printer *printer = [Printer getPrinterWithCode:_printerCodeList[item]];
        cell.lblPrinterName.text = printer.name;
        if([Utility isStringEmpty:printer.model])
        {
            cell.lblModel.text = @"ค้นหาเครื่องพิมพ์";
            cell.lblModelTopConstant.constant = 13;
        }
        else
        {
            cell.lblModel.text = printer.model;
            cell.lblModelTopConstant.constant = 8;
        }
        
        if([Utility isStringEmpty:printer.macAddress])
        {
            cell.lblPortAndMacAddress.text = printer.portName;
        }
        else
        {
            cell.lblPortAndMacAddress.text = [NSString stringWithFormat:@"%@ (%@)", printer.portName, printer.macAddress];
        }
        cell.imVwStatus.image = printer.printerStatus?[UIImage imageNamed:@"connected"]:[UIImage imageNamed:@"offline"];
        [cell.btnTrash addTarget:self action:@selector(deletePort:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnTrash.tag = printer.printerID;
        
        
        return cell;
    }
    else if([collectionView isEqual:colVwStatus])
    {
        switch (item)
        {
            case 0:
            case 1:
            {
                CustomCollectionViewCellLabel *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierLabel forIndexPath:indexPath];
                
                cell.lblTextLabel.text = item == 0?@"ชำระเงิน":@"ใบสั่งรายการอาหาร";                                
                return cell;
            }
                break;
            case 2:
            {                
                CustomCollectionViewCellLabelAndSwitch *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierLabelAndSwitch forIndexPath:indexPath];
                cell.contentView.userInteractionEnabled = NO;
                
                
                cell.lblTextLabel.text = @"พิมพ์ใบแจ้งหนี้ก่อนชำระเงิน";
                cell.lblLeadingConstant.constant = (cell.frame.size.width - 279)/2.0;
                NSInteger printFlag = [[Setting getSettingValueWithKeyName:@"printInvoice"] integerValue];
                cell.swtValue.on = printFlag;
                cell.swtValue.tag = 1;
                [cell.swtValue addTarget:self action:@selector(printerStatusSwitchChanged:) forControlEvents:UIControlEventValueChanged];
                return cell;
            }
                break;
            case 3:
            {
                CustomCollectionViewCellLabelAndSwitch *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierLabelAndSwitch forIndexPath:indexPath];
                cell.contentView.userInteractionEnabled = NO;
                
                
                cell.lblTextLabel.text = @"พิมพ์และตัดทีละรายการ";
                cell.lblLeadingConstant.constant = (cell.frame.size.width - 315)/2.0;
                NSInteger printFlag = [[Setting getSettingValueWithKeyName:@"printOrderKitchenByItem"] integerValue];
                cell.swtValue.on = printFlag;
                cell.swtValue.tag = 2;
                [cell.swtValue addTarget:self action:@selector(printerStatusSwitchChanged:) forControlEvents:UIControlEventValueChanged];
                return cell;
            }
                break;
            case 4:
            {
                CustomCollectionViewCellLabelSwitchText *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierLabelSwitchText forIndexPath:indexPath];
                cell.contentView.userInteractionEnabled = NO;
                
                
                cell.lblTextLabel.text = @"พิมพ์โปรโมชั่นท้ายใบเสร็จ";
                cell.lblLeadingConstant.constant = (cell.frame.size.width - 279)/2.0;
                NSInteger printFlag = [[Setting getSettingValueWithKeyName:@"printPromotionReceipt"] integerValue];
                cell.swtValue.on = printFlag;
                cell.swtValue.tag = 3;
                [cell.swtValue addTarget:self action:@selector(printerStatusSwitchChanged:) forControlEvents:UIControlEventValueChanged];
                cell.txtTextValue.hidden = YES;
                cell.btnTrash.hidden = YES;
                return cell;
            }
                break;
            case 5:
            {
                CustomCollectionViewCellLabelSwitchText *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierLabelSwitchText forIndexPath:indexPath];
                cell.contentView.userInteractionEnabled = NO;
                
                
                cell.lblTextLabel.text = @"พิมพ์สรุปรายการที่สั่งทั้งหมด";
                cell.lblLeadingConstant.constant = (cell.frame.size.width - 315)/2.0;
                NSInteger printFlag = [[Setting getSettingValueWithKeyName:@"printFoodCheckList"] integerValue];
                NSInteger printerID = [[Setting getSettingValueWithKeyName:@"foodCheckList"] integerValue];
                Printer *printer = [Printer getPrinter:printerID];
                cell.swtValue.on = printFlag;
                cell.swtValue.tag = 4;
                [cell.swtValue addTarget:self action:@selector(printerStatusSwitchChanged:) forControlEvents:UIControlEventValueChanged];
                cell.txtTextValue.hidden = NO;
                cell.btnTrash.hidden = NO;
                _txtFoodCheckList = cell.txtTextValue;
                cell.txtTextValue.tintColor = [UIColor clearColor];
                cell.txtTextValue.text = printer?printer.name:@"ระบุเครื่องพิมพ์";
                cell.txtTextValue.textColor = printer?[UIColor blackColor]:mPlaceHolder;
                cell.txtTextValue.delegate = self;
                _btnTrashFoodCheckList = cell.btnTrash;
                [cell.btnTrash addTarget:self action:@selector(deleteFoodCheckList:) forControlEvents:UIControlEventTouchUpInside];
                
                return cell;
            }
                break;
            default:
                break;
        }
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([collectionView isEqual:colVwSetUpPrinter])
    {
        _selectedPrinter = [Printer getPrinterWithCode:_printerCodeList[indexPath.item]];
        [self performSegueWithIdentifier:@"PushSearchPortViewController" sender:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"PushSearchPortViewController"])
    {
        SearchPortViewController *vc = segue.destinationViewController;
        vc.printer = _selectedPrinter;
    }
}

#pragma mark <UICollectionViewDelegate>


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([collectionView isEqual:colVwSetUpPrinter])
    {
        return CGSizeMake(collectionView.frame.size.width, 80);
    }
    else if([collectionView isEqual:colVwStatus])
    {
        if(indexPath.item == 4 || indexPath.item == 5)
        {
            return CGSizeMake(collectionView.frame.size.width/2, 120);
        }
        else
        {
            return CGSizeMake(collectionView.frame.size.width/2, 60);
        }        
    }
    return CGSizeMake(collectionView.frame.size.width, 44);
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)colVwSetUpPrinter.collectionViewLayout;
        
        [layout invalidateLayout];
        [colVwSetUpPrinter reloadData];
    }
    
    
    {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)colVwStatus.collectionViewLayout;
        
        [layout invalidateLayout];
        [colVwStatus reloadData];
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
    [self performSegueWithIdentifier:@"segUnwindToSetting" sender:self];
}

- (IBAction)refreshStatus:(id)sender
{
    [self checkPrinterStatus];
    [colVwSetUpPrinter reloadData];
}

-(void)checkPrinterStatus
{
    [self loadingOverlayView];
    BOOL result = NO;
    SMPort *port = nil;
    
    
    for(int i=0; i<[_printerCodeList count]; i++)
    {
        Printer *printer = [Printer getPrinterWithCode:_printerCodeList[i]];
        NSString *strPortName = printer.portName;
        if([Utility isStringEmpty:strPortName])
        {
//            [_printerStatusList addObject:@""];
            printer.printerStatus = 0;
            continue;
        }
        
        //check status
        @try
        {
            while (YES)
            {
//                port = [SMPort getPort:[AppDelegate getPortName] :[AppDelegate getPortSettings] :10000];     // 10000mS!!!
                port = [SMPort getPort:strPortName :[AppDelegate getPortSettings] :10000];     // 10000mS!!!
                if (port == nil)
                {
                    //printer offline
//                    i = 4;
//                    [_printerStatusList removeAllObjects];
//                    [_printerStatusList addObject:@""];
                    printer.printerStatus = 0;
                    break;
                }
                
                StarPrinterStatus_2 printerStatus;
                
                [port getParsedStatus:&printerStatus :2];
                
                if (printerStatus.offline == SM_TRUE) {
                    [_statusCellArray addObject:@[@"Online", @"Offline", [UIColor redColor]]];
//                    [_printerStatusList addObject:@""];
                    printer.printerStatus = 0;
                }
                else {
                    [_statusCellArray addObject:@[@"Online", @"Online",  [UIColor blueColor]]];
//                    [_printerStatusList addObject:@"Online"];
                    printer.printerStatus = 1;
                }
                
                if (printerStatus.offline == SM_TRUE) {
                    [_firmwareInfoCellArray addObject:@[@"Unable to get F/W info. from an error.", @"", [UIColor redColor]]];
                    
                    result = YES;
                    break;
                }
                else {
                    NSDictionary *firmwareInformation = [port getFirmwareInformation];
                    
                    if (firmwareInformation == nil) {
                        break;
                    }
                    
                    [_firmwareInfoCellArray addObject:@[@"Model Name",       [firmwareInformation objectForKey:@"ModelName"],       [UIColor blueColor]]];
                    
                    [_firmwareInfoCellArray addObject:@[@"Firmware Version", [firmwareInformation objectForKey:@"FirmwareVersion"], [UIColor blueColor]]];
                    
                    result = YES;
                    break;
                }
            }
        }
        @catch (PortException *exc) {
        }
        @finally {
            if (port != nil) {
                [SMPort releasePort:port];
                
                port = nil;
            }
        }
    }
    
    
    if (result == NO) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Fail to Open Port" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
    }
    [self removeOverlayViews];
}

- (IBAction)printerSwitchChanged:(id)sender
{
    Setting *setting = [Setting getSettingWithKeyName:@"printBill"];
    setting.value = swPrinterOn.on?@"1":@"0";
    setting.modifiedUser = [Utility modifiedUser];
    setting.modifiedDate = [Utility currentDateTime];
    [self.homeModel updateItems:dbSetting withData:setting actionScreen:@"update setting(keyName = printBill) in setUpPrinter screen "];
}

- (void)printerStatusSwitchChanged:(id)sender
{
    UISwitch *printerStatusSwitch = sender;
    Setting *setting;
    switch (printerStatusSwitch.tag)
    {
        case 1:
        {
            setting = [Setting getSettingWithKeyName:@"printInvoice"];
            setting.value = swPrinterOn.on?@"1":@"0";
        }
            break;
        case 2:
        {
            setting = [Setting getSettingWithKeyName:@"printOrderKitchenByItem"];
            setting.value = swPrinterOn.on?@"1":@"0";
        }
            break;
        case 3:
        {
            setting = [Setting getSettingWithKeyName:@"printPromotionReceipt"];
            setting.value = swPrinterOn.on?@"1":@"0";
        }
            break;
        case 4:
        {
            setting = [Setting getSettingWithKeyName:@"printFoodCheckList"];
            setting.value = swPrinterOn.on?@"1":@"0";
            _txtFoodCheckList.enabled = printerStatusSwitch.on;
            _btnTrashFoodCheckList.enabled = printerStatusSwitch.on;
        }
            
            break;
        default:
            break;
    }
    
    setting.modifiedUser = [Utility modifiedUser];
    setting.modifiedDate = [Utility currentDateTime];
    [self.homeModel updateItems:dbSetting withData:setting actionScreen:@"update printer status setting in setUpPrinter screen "];
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController
{
    
    // return YES if the Popover should be dismissed
    // return NO if the Popover should not be dismissed
    return YES;
}

-(void)deletePort:(id)sender
{
    UIButton *button = sender;
    NSInteger printerID = button.tag;
    Printer *printer = [Printer getPrinter:printerID];
    printer.model = @"";
    printer.macAddress = @"";
    printer.portName = @"";
    printer.modifiedUser = [Utility modifiedUser];
    printer.modifiedDate = [Utility currentDateTime];
    [self.homeModel updateItems:dbPrinter withData:printer actionScreen:@"delete printer in setUpPrinter screen"];
    
    [colVwSetUpPrinter reloadData];
}

-(void)deleteFoodCheckList:(id)sender
{
    _txtFoodCheckList.text = @"ระบุเครื่องพิมพ์";
    _txtFoodCheckList.textColor = mPlaceHolder;
    Setting *setting = [Setting getSettingWithKeyName:@"foodCheckList"];
    setting.value = @"0";
    setting.modifiedUser = [Utility modifiedUser];
    setting.modifiedDate = [Utility currentDateTime];
    
    [self.homeModel updateItems:dbSetting withData:setting actionScreen:@"delete foodCheckList in setUpPrinter screen"];
}

-(void)setFoodCheckListTextBox:(NSString *)printerName
{
    _txtFoodCheckList.text = printerName;
    _txtFoodCheckList.textColor = [UIColor blackColor];
}

- (IBAction)setUpMenuTypePrint:(id)sender
{
    [self performSegueWithIdentifier:@"segSetUpMenuTypePrint" sender:self];
}


@end
