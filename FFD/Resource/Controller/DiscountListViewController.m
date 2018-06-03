//
//  DiscountListViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 11/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "DiscountListViewController.h"
#import "DiscountAddViewController.h"
#import "CustomTableViewCellLabelLabel.h"
#import "Discount.h"


@interface DiscountListViewController ()
{
    NSMutableArray *_discountList;
    Discount *_editDiscount;
    BOOL booShowAll;
}
@end

@implementation DiscountListViewController
static NSString * const reuseIdentifierLabelLabel = @"CustomTableViewCellLabelLabel";


@synthesize btnAdd;
@synthesize btnReorder;
@synthesize btnShowAll;
@synthesize tbvDiscountList;

- (void)unwindToSettingDetail
{
    [self performSegueWithIdentifier:@"segUnwindToSettingDetail" sender:self];
}

- (IBAction)unwindToDiscountList:(UIStoryboardSegue *)segue
{
    [self getDataList];
}

-(void)loadView
{
    [super loadView];
    [self loadViewProcess];
}

-(void)loadViewProcess
{
    [self getDataList];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    tbvDiscountList.dataSource = self;
    tbvDiscountList.delegate = self;
    
    
    [self setButtonDesign:btnReorder];
    [self setButtonDesign:btnShowAll];
    [self setButtonDesign:btnAdd];
    
    
    [btnShowAll setTitle:@"แสดงทั้งหมด" forState:UIControlStateNormal];
    booShowAll = NO;
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelLabel bundle:nil];
        [tbvDiscountList registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelLabel];
    }
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return [_discountList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger item = indexPath.item;
    CustomTableViewCellLabelLabel *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelLabel forIndexPath:indexPath];
    
    Discount *discount = _discountList[item];
    NSString *strDiscountAmount = [Utility formatDecimal:discount.discountAmount withMinFraction:0 andMaxFraction:2];
    NSString *strDiscountType = discount.discountType == 1?@" บาท":@"%";
    NSString *strRemark = [Utility isStringEmpty:discount.remark]?@"":[NSString stringWithFormat:@" (%@)",discount.remark];
    cell.lblTextLabel.text = [NSString stringWithFormat:@"%@%@%@",strDiscountAmount,strDiscountType,strRemark];
    cell.lblDetailTextLabel.text = @"";
    
    
    [cell removeGestureRecognizer:cell.longPressGestureRecognizer];
    [cell.longPressGestureRecognizer addTarget:self action:@selector(handleLongPressEditDiscount:)];
    [cell addGestureRecognizer:cell.longPressGestureRecognizer];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomTableViewCellLabelLabel *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = mLightBlueColor;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomTableViewCellLabelLabel *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
    [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
    [label setFont:[UIFont boldSystemFontOfSize:14]];
    [label setText:@"ส่วนลด"];
    label.textAlignment = NSTextAlignmentCenter;
    
    
    [view addSubview:label];
    [view setBackgroundColor:mLightBlueColor]; //your background color...
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (IBAction)addDiscount:(id)sender
{
    _editDiscount = nil;
    [self performSegueWithIdentifier:@"segAddEditDiscount" sender:self];
}

- (IBAction)showAll:(id)sender
{
//    if([btnShowAll.titleLabel.text isEqualToString:@"แสดงทั้งหมด"])
    booShowAll = !booShowAll;
    if(booShowAll)
    {
        [btnShowAll setTitle:@"เฉพาะที่ใช้งาน" forState:UIControlStateNormal];
        [self loadingOverlayView];
        self.homeModel = [[HomeModel alloc]init];
        self.homeModel.delegate = self;
        [self.homeModel downloadItems:dbDiscount];
    }
    else
    {
        [btnShowAll setTitle:@"แสดงทั้งหมด" forState:UIControlStateNormal];
        [self getDataList];
    }
}

- (IBAction)reorder:(id)sender
{
    if([btnReorder.titleLabel.text isEqualToString:@"จัดเรียง"])
    {
        [btnReorder setTitle:@"แก้ไข" forState:UIControlStateNormal];
        tbvDiscountList.editing = YES;
    }
    else
    {
        [btnReorder setTitle:@"จัดเรียง" forState:UIControlStateNormal];
        tbvDiscountList.editing = NO;
    }
}

- (void)getDataList
{
//    if([btnShowAll.titleLabel.text isEqualToString:@"แสดงทั้งหมด"])
    if(booShowAll)
    {
        _discountList = [Discount getDiscountListWithStatus:1];
        [_discountList addObjectsFromArray:[Discount getDiscountListWithStatus:0]];
        
    }
    else
    {
        _discountList = [Discount getDiscountListWithStatus:1];
    }
    
    [tbvDiscountList reloadData];
}

- (void)itemsDownloaded:(NSArray *)items
{
    [super itemsDownloaded:items];
    
    if(self.homeModel.propCurrentDB == dbDiscount)
    {
        _discountList = [items[0] mutableCopy];
        [Discount addList:_discountList];
        [self getDataList];
        
        
        
        [self removeOverlayViews];
    }
}

- (void)handleLongPressEditDiscount:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:tbvDiscountList];
    NSIndexPath * tappedIP = [tbvDiscountList indexPathForRowAtPoint:point];
    UITableViewCell *cell = [tbvDiscountList cellForRowAtIndexPath:tappedIP];//[tbvDiscountList cellForItemAtIndexPath:tappedIP];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:
     [UIAlertAction actionWithTitle:@"แก้ไข"
                              style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
      {
          _editDiscount = _discountList[tappedIP.item];
          [self performSegueWithIdentifier:@"segAddEditDiscount" sender:self];
          
      }]];
    
    [alert addAction:
     [UIAlertAction actionWithTitle:@"ลบ"
                              style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
      {
          UIAlertController* alert2 = [UIAlertController alertControllerWithTitle:nil
                                                                          message:nil
                                                                   preferredStyle:UIAlertControllerStyleActionSheet];
          [alert2 addAction:
           [UIAlertAction actionWithTitle:@"ยืนยันลบรายการ"
                                    style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
            {
                _editDiscount = _discountList[tappedIP.item];
                [Discount removeObject:_editDiscount];
                [self.homeModel deleteItems:dbDiscount withData:_editDiscount actionScreen:@"delete discount in discount screen"];
                
                [self getDataList];
            }]];
          [alert2 addAction:
           [UIAlertAction actionWithTitle:@"ยกเลิก"
                                    style:UIAlertActionStyleCancel
                                  handler:^(UIAlertAction *action) {}]];
          
          
          
          if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
          {
              [alert2 setModalPresentationStyle:UIModalPresentationPopover];
              
              UIPopoverPresentationController *popPresenter = [alert2 popoverPresentationController];
              CGRect frame = cell.bounds;
              frame.origin.y = frame.origin.y-15;
              popPresenter.sourceView = cell;
              popPresenter.sourceRect = frame;
          }
          
          
          [self presentViewController:alert2 animated:YES completion:nil];
          
      }]];
    
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        [alert setModalPresentationStyle:UIModalPresentationPopover];
        
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        CGRect frame = cell.bounds;
        frame.origin.y = frame.origin.y-15;
        popPresenter.sourceView = cell;
        popPresenter.sourceRect = frame;
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segAddEditDiscount"])
    {
        DiscountAddViewController *vc = segue.destinationViewController;
        vc.editDiscount = _editDiscount;
    }
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToSetting" sender:self];
}
@end
