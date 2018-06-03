//
//  BranchAddViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 4/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "BranchAddViewController.h"
#import "CustomCollectionViewCellLabelTextFixedWidth.h"
#import "CustomCollectionViewCellLabelTextView.h"
#import "SubDistrict.h"
#import "District.h"
#import "Province.h"
#import "ZipCode.h"
#import <QuartzCore/QuartzCore.h> 


@interface BranchAddViewController ()
{
    NSInteger _selectedIndexSubDistrict;
    NSInteger _selectedIndexDistrict;
    NSInteger _selectedIndexProvince;
    NSInteger _selectedIndexZipCode;
    NSInteger _selectedIndexStatus;
    NSMutableArray *_subDistrictList;
    NSMutableArray *_districtList;
    NSMutableArray *_provinceList;
    NSMutableArray *_zipCodeList;
    NSArray *_statusList;
    NSMutableArray *_allSubDistrictList;
    NSMutableArray *_allDistrictList;
    NSMutableArray *_allProvinceList;
    NSMutableArray *_allZipCodeList;
    Branch *_editingBranch;
    Branch *_firstLoadBranch;
}
@end

@implementation BranchAddViewController
static NSString * const reuseIdentifierLabelTextFixedWidth = @"CustomCollectionViewCellLabelTextFixedWidth";
static NSString * const reuseIdentifierLabelTextView = @"CustomCollectionViewCellLabelTextView";

@synthesize colVwBranchAdd;
@synthesize dtPicker;
@synthesize pickerVw;
@synthesize editBranch;
@synthesize btnConfirm;
@synthesize btnCancel;



- (IBAction)datePickerChanged:(id)sender
{
    UITextField *textField = (UITextField *)[self.view viewWithTag:13];
    if([textField isFirstResponder])
    {
        textField.text = [Utility dateToString:dtPicker.date toFormat:@"d MMM yyyy"];
        _editingBranch.startDate = dtPicker.date;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    if(textField.tag == 4)
    {
        [pickerVw selectRow:_selectedIndexProvince inComponent:0 animated:NO];
        Province *province = _provinceList[_selectedIndexProvince];
        textField.text = province.name;
        _editingBranch.province = province.name;
    }
    else if(textField.tag == 12)
    {
        NSString *strStatus = _statusList[_selectedIndexStatus];
        textField.text = strStatus;
        _editingBranch.status = _selectedIndexStatus+1;
        [pickerVw selectRow:_selectedIndexStatus inComponent:0 animated:NO];
    }
    else if(textField.tag == 13)
    {
        NSString *strDate = textField.text;
        if([strDate isEqualToString:@""])
        {
            [dtPicker setDate:[Utility currentDateTime]];
            textField.text = [Utility dateToString:[Utility currentDateTime] toFormat:@"d MMM yyyy"];
            _editingBranch.startDate = dtPicker.date;
        }
        else
        {
            NSDate *datePeriod = [Utility stringToDate:strDate fromFormat:@"d MMM yyyy"];
            [dtPicker setDate:datePeriod];
        }
    }
    else if(textField.tag == 9 || textField.tag == 10 || textField.tag == 11)
    {
        if([textField.text isEqualToString:@"0"])
        {
            textField.text = @"";
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag == 9 || textField.tag == 10 || textField.tag == 11)
    
    {
        NSString *resultingString = [textField.text stringByReplacingCharactersInRange: range withString: string];
        
        // The user deleting all input is perfectly acceptable.
        if ([resultingString length] == 0) {
            return true;
        }
        
        NSInteger holder;
        
        NSScanner *scan = [NSScanner scannerWithString: resultingString];
        
        return [scan scanInteger: &holder] && [scan isAtEnd];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 100:
        {
            _editingBranch.branchNo = [Utility trimString:textField.text];
        }
        break;
        case 1:
        {
            _editingBranch.name = [Utility trimString:textField.text];
        }
        break;
        case 3:
        {
            _editingBranch.district = [Utility trimString:textField.text];
        }
        break;
        case 5:
        {
            _editingBranch.postCode = [Utility trimString:textField.text];
        }
        break;
        case 6:
        {
            _editingBranch.country = [Utility trimString:textField.text];
        }
        break;
        case 8:
        {
            _editingBranch.phoneNo = [Utility removeDashAndSpaceAndParenthesis:textField.text];
        }
        break;
        case 9:
        {
            _editingBranch.tableNum = [textField.text integerValue];
        }
        break;
        case 10:
        {
            _editingBranch.customerNumMax = [textField.text integerValue];
        }
        break;
        case 11:
        {
            _editingBranch.employeePermanentNum = [textField.text integerValue];
        }
        break;
        default:
            break;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    switch (textView.tag)
    {
        case 2:
        {
            _editingBranch.street = [Utility replaceNewLineForDB:[Utility trimString:textView.text]];
        }
        break;
        case 14:
        {
            _editingBranch.remark = [Utility replaceNewLineForDB:[Utility trimString:textView.text]];
        }
        break;
        default:
        break;
    }
}
-(void)loadView
{
    [super loadView];
    
    [dtPicker setLocale: [NSLocale localeWithLocaleIdentifier:@"en"]];
    [dtPicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dtPicker removeFromSuperview];
    
    
    [pickerVw removeFromSuperview];    
    pickerVw.delegate = self;
    pickerVw.dataSource = self;
    pickerVw.showsSelectionIndicator = YES;
    
    
    _statusList = @[@"ให้บริการ",@"จะเปิดในอนาคต",@"ปิดบริการ"];
    _allSubDistrictList = [SubDistrict getSubDistrictList];
    _allDistrictList = [District getDistrictList];
    _allProvinceList = [Province getProvinceList];
    _allZipCodeList = [ZipCode getZipCodeList];
    _subDistrictList = _allSubDistrictList;
    _districtList = _allDistrictList;
    _provinceList = _allProvinceList;
    _zipCodeList = _allZipCodeList;
    
    if(editBranch)
    {
        _editingBranch = [editBranch copy];
        _firstLoadBranch = [editBranch copy];
    }
    else
    {
        _editingBranch = [[Branch alloc]initWithDbName:@"" branchNo:@"" name:@"" street:@"" district:@"" province:@"" postCode:@"" subDistrictID:0 districtID:0 provinceID:0 zipCodeID:0 country:@"ไทย" map:@"" phoneNo:@"" tableNum:0 customerNumMax:0 employeePermanentNum:0 status:1 percentVat:0 customerApp:1 imageUrl:@"" startDate:[Utility notIdentifiedDate] remark:@"" deviceTokenReceiveOrder:@""];
//        _editingBranch = [[Branch alloc]initWithDbName:@"" branchNo:@"" name:@"" street:@"" district:@"" province:@"" postCode:@"" subDistrictID:0 districtID:0 provinceID:0 zipCodeID:0 country:@"ไทย" map:@"" phoneNo:@"" tableNum:0 customerNumMax:0 employeePermanentNum:0 status startDate:[Utility notIdentifiedDate] remark:@""];
        _firstLoadBranch = [_editingBranch copy];
    }
    _selectedIndexProvince = [Province getSelectedIndexWithName:_editingBranch.province provinceList:_provinceList];
    _selectedIndexStatus = _editingBranch.status-1;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelTextFixedWidth bundle:nil];
        [colVwBranchAdd registerNib:nib forCellWithReuseIdentifier:reuseIdentifierLabelTextFixedWidth];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelTextView bundle:nil];
        [colVwBranchAdd registerNib:nib forCellWithReuseIdentifier:reuseIdentifierLabelTextView];
    }
    
    
    // Register cell classes
    colVwBranchAdd.delegate = self;
    colVwBranchAdd.dataSource = self;
    
    
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture setCancelsTouchesInView:NO];
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return  1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 15;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger item = indexPath.item;
    NSArray *headerList = @[@"เลขที่สาขา",@"ชื่อสาขา",@"ที่อยู่",@"เขต/อำเภอ",@"จังหวัด",@"รหัสไปรษณีย์",@"ประเทศ",@"แผนที่",@"เบอร์ติดต่อ",@"จำนวนโต๊ะ",@"จำนวนลูกค้าสูงสุดต่อรอบ",@"จำนวนพนักงานประจำ",@"สถานะ",@"วันเริ่มกิจการ",@"หมายเหตุ"];
    switch (item)
    {
        case 0:
        case 1:
        case 3:
        case 5:
        case 6:
        case 8:
        
        case 4:
        case 12:
        
        case 13:
        {
            CustomCollectionViewCellLabelTextFixedWidth *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierLabelTextFixedWidth forIndexPath:indexPath];
            cell.contentView.userInteractionEnabled = NO;
            
            
            NSDictionary *attribute = @{NSForegroundColorAttributeName:mRed};
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"*" attributes:attribute];
            
            
            NSDictionary *attribute2 = @{NSForegroundColorAttributeName:mDarkGrayColor};
            NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:headerList[item] attributes:attribute2];
            
            
            [attrString appendAttributedString:attrString2];
            cell.lblTitle.attributedText = attrString;
            cell.lblTitle.textAlignment = NSTextAlignmentRight;
            cell.lblWidthConstant.constant = 150;
            
            
            cell.txtValue.tag = item==0?100:item;
            cell.txtValue.delegate = self;
            cell.txtValue.layer.borderWidth = 1;
            cell.txtValue.textAlignment = NSTextAlignmentLeft;
            cell.txtValue.inputView = nil;
            switch (item)
            {
                case 0:
                {
                    cell.txtValue.text = _editingBranch.branchNo;
                }
                break;
                case 1:
                {
                    cell.txtValue.text = _editingBranch.name;
                }
                break;
                case 3:
                {
                    cell.txtValue.text = _editingBranch.district;
                }
                break;
                case 5:
                {
                    cell.txtValue.text = _editingBranch.postCode;
                }
                break;
                case 6:
                {
                    cell.txtValue.text = _editingBranch.country;
                }
                break;
                case 8:
                {
                    cell.txtValue.text = [Utility insertDashForPhoneNo:_editingBranch.phoneNo];
                }
                break;
                case 4:
                {
                    cell.txtValue.inputView = pickerVw;
                    cell.txtValue.text = _editingBranch.province;
                }
                break;
                case 12:
                {
                    cell.txtValue.inputView = pickerVw;
                    cell.txtValue.text = _statusList[_editingBranch.status-1];
                }
                break;
                case 13:
                {
                    cell.txtValue.inputView = dtPicker;
                    cell.txtValue.text = [Utility dateToString:_editingBranch.startDate toFormat:@"d MMM yyyy"];
                }
                break;
                default:
                break;
            }
            
            return cell;
        }
        break;
        case 7:
        case 9:
        case 10:
        case 11:
        {
            CustomCollectionViewCellLabelTextFixedWidth *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierLabelTextFixedWidth forIndexPath:indexPath];
            cell.contentView.userInteractionEnabled = NO;
            
            
            cell.lblTitle.text = headerList[item];
            cell.lblTitle.textAlignment = NSTextAlignmentRight;
            cell.lblWidthConstant.constant = 150;
            
            
            cell.txtValue.tag = item;
            cell.txtValue.delegate = self;
            cell.txtValue.layer.borderWidth = 1;
            cell.txtValue.textAlignment = NSTextAlignmentLeft;
            cell.txtValue.inputView = nil;
            switch (item)
            {
                case 7:
                {
                    cell.txtValue.text = @"";
                }
                break;
                case 9:
                {
                    cell.txtValue.text = [NSString stringWithFormat:@"%ld",_editingBranch.tableNum];
                }
                break;
                case 10:
                {
                    cell.txtValue.text = [NSString stringWithFormat:@"%ld",_editingBranch.customerNumMax];
                }
                break;
                case 11:
                {
                    cell.txtValue.text = [NSString stringWithFormat:@"%ld",_editingBranch.employeePermanentNum];
                }
                break;
                default:
                break;
            }
            
            return cell;
        }
            break;
        case 2:
        {
            CustomCollectionViewCellLabelTextView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierLabelTextView forIndexPath:indexPath];
            cell.contentView.userInteractionEnabled = NO;
            cell.lblTitle.textAlignment = NSTextAlignmentRight;
            
            
            NSDictionary *attribute = @{NSForegroundColorAttributeName:mRed};
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"*" attributes:attribute];
            
        
            NSDictionary *attribute2 = @{NSForegroundColorAttributeName:mDarkGrayColor};
            NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:headerList[item] attributes:attribute2];
            
            
            [attrString appendAttributedString:attrString2];
            cell.lblTitle.attributedText = attrString;
            
            
            
            cell.txtValue.tag = item;
            cell.txtValue.delegate = self;
            cell.txtValue.layer.borderWidth = 1;
            cell.txtValue.layer.borderColor = [UIColor blackColor].CGColor;
            cell.txtValue.textAlignment = NSTextAlignmentLeft;
            cell.txtValue.text = [Utility replaceNewLineForApp:_editingBranch.street];
            
            return cell;
        }
        break;
        case 14:
        {
            CustomCollectionViewCellLabelTextView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierLabelTextView forIndexPath:indexPath];
            cell.contentView.userInteractionEnabled = NO;
            cell.lblTitle.textAlignment = NSTextAlignmentRight;
            cell.lblTitle.text = headerList[item];
            
           
            
            cell.txtValue.tag = item;
            cell.txtValue.delegate = self;
            cell.txtValue.layer.borderWidth = 1;
            cell.txtValue.layer.borderColor = [UIColor blackColor].CGColor;
            cell.txtValue.textAlignment = NSTextAlignmentLeft;
            cell.txtValue.text = [Utility replaceNewLineForApp:_editingBranch.remark];
            
            return cell;
        }
        default:
            break;
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}

#pragma mark <UICollectionViewDelegate>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float height = indexPath.item == 2 || indexPath.item == 14?60:44;
    CGSize size = CGSizeMake(collectionView.frame.size.width, height);
    return size;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)colVwBranchAdd.collectionViewLayout;
    
    [layout invalidateLayout];
    [colVwBranchAdd reloadData];
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

- (IBAction)goToSetting:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToSetting" sender:self];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component
{
    // Handle the selection
    UITextField *txtProvince = (UITextField *)[self.view viewWithTag:4];
    UITextField *txtStatus = (UITextField *)[self.view viewWithTag:12];
    if([txtProvince isFirstResponder])
    {
        _selectedIndexProvince = row;
        Province *province = _provinceList[row];
        txtProvince.text = province.name;
        [txtProvince resignFirstResponder];
        _editingBranch.province = province.name;
    }
    if([txtStatus isFirstResponder])
    {
        _selectedIndexStatus = row;
        NSString *strStatus = _statusList[row];
        txtStatus.text = strStatus;
        [txtStatus resignFirstResponder];
        _editingBranch.status = row+1;
    }
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    UITextField *txtProvince = (UITextField *)[self.view viewWithTag:4];
    UITextField *txtStatus = (UITextField *)[self.view viewWithTag:12];
    if([txtProvince isFirstResponder])
    {
        return [_provinceList count];
    }
    else if([txtStatus isFirstResponder])
    {
        return [_statusList count];
    }
    
    return 0;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *strText = @"";
    UITextField *txtProvince = (UITextField *)[self.view viewWithTag:4];
    UITextField *txtStatus = (UITextField *)[self.view viewWithTag:12];
    if([txtProvince isFirstResponder])
    {
        Province *province = _provinceList[row];
        strText = province.name;
    }
    else if([txtStatus isFirstResponder])
    {
        NSString *strStatus = _statusList[row];
        strText = strStatus;
    }
    
    return strText;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return self.view.frame.size.width;
}


- (IBAction)confirmBranch:(id)sender
{
    if(![self validateBranch])
    {
        return;
    }
    
    
    if([_firstLoadBranch editBranch:_editingBranch])
    {
        if(editBranch)
        {
            editBranch = [Branch copyFrom:_editingBranch to:editBranch];
            [self.homeModel updateItems:dbBranch withData:editBranch actionScreen:@"update branch in branchAdd screen"];
            [self showAlert:@"" message:@"แก้ไขข้อมูลสาขาสำเร็จ" method:@selector(unwindToBranchList)];
        }
        else
        {
            [self loadingOverlayView];
            [self.homeModel insertItems:dbBranch withData:@[_editingBranch,[[NSUserDefaults standardUserDefaults] stringForKey:USERNAME]] actionScreen:@"insert branch in branchAdd screen"];
        }
    }
    else
    {
        [self performSegueWithIdentifier:@"segUnwindToBranchList" sender:self];
    }
}

- (IBAction)cancelBranch:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToBranchList" sender:self];
}

-(BOOL)validateBranch
{
//    NSArray *headerList = @[@"เลขที่สาขา",@"ชื่อสาขา",@"ที่อยู่",@"เขต/อำเภอ",@"จังหวัด",@"รหัสไปรษณีย์",@"ประเทศ",@"แผนที่",@"เบอร์ติดต่อ",@"จำนวนโต๊ะ",@"จำนวนลูกค้าสูงสุดต่อรอบ",@"จำนวนพนักงานประจำ",@"สถานะ",@"วันเริ่มกิจการ",@"หมายเหตุ"];
    UITextField *txtBranchNo = (UITextField *)[self.view viewWithTag:100];
    UITextField *txtBranchName = (UITextField *)[self.view viewWithTag:1];
    UITextView *txtStreet = (UITextView *)[self.view viewWithTag:2];
    UITextField *txtDistrict = (UITextField *)[self.view viewWithTag:3];
    UITextField *txtProvince = (UITextField *)[self.view viewWithTag:4];
    UITextField *txtPostCode = (UITextField *)[self.view viewWithTag:5];
    UITextField *txtCountry = (UITextField *)[self.view viewWithTag:6];
    UITextField *txtPhoneNo = (UITextField *)[self.view viewWithTag:8];
    UITextField *txtStatus = (UITextField *)[self.view viewWithTag:12];
    UITextField *txtStartDate = (UITextField *)[self.view viewWithTag:13];
    if([Utility isStringEmpty:txtBranchNo.text])
    {
        [self showAlert:@"" message:@"กรุณาใส่หมายเลขสาขา"];
        return NO;
    }
    if([Utility isStringEmpty:txtBranchName.text])
    {
        [self showAlert:@"" message:@"กรุณาใส่ชื่อสาขา"];
        return NO;
    }
    if([Utility isStringEmpty:txtStreet.text])
    {
        [self showAlert:@"" message:@"กรุณาใส่ที่อยู่"];
        return NO;
    }
    if([Utility isStringEmpty:txtDistrict.text])
    {
        [self showAlert:@"" message:@"กรุณาใส่เขต"];
        return NO;
    }
    if([Utility isStringEmpty:txtProvince.text])
    {
        [self showAlert:@"" message:@"กรุณาเลือกจังหวัด"];
        return NO;
    }
    if([Utility isStringEmpty:txtPostCode.text])
    {
        [self showAlert:@"" message:@"กรุณาใส่รหัสไปรษณีย์"];
        return NO;
    }if([Utility isStringEmpty:txtCountry.text])
    {
        [self showAlert:@"" message:@"กรุณาใส่ประเทศ"];
        return NO;
    }
    if([Utility isStringEmpty:txtPhoneNo.text])
    {
        [self showAlert:@"" message:@"กรุณาใส่หมายเลขโทรศัพท์"];
        return NO;
    }
    if([Utility isStringEmpty:txtStatus.text])
    {
        [self showAlert:@"" message:@"กรุณาเลือกสถานะ"];
        return NO;
    }
    if([Utility isStringEmpty:txtStartDate.text])
    {
        [self showAlert:@"" message:@"กรุณาใส่วันเริ่มกิจการ"];
        return NO;
    }
    return YES;
}

-(void)itemsInserted
{
    [self removeOverlayViews];
    [self showAlert:@"" message:@"เพิ่มข้อมูลสาขาสำเร็จ" method:@selector(unwindToBranchList)];
}

-(void)unwindToBranchList
{
    [self performSegueWithIdentifier:@"segUnwindToBranchList" sender:self];
}

- (void)alertMsg:(NSString *)msg
{
    [self removeOverlayViews];
    [self showAlert:@"" message:msg];
}
@end
