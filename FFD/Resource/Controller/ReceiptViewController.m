//
//  ReceiptViewController.m
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/16/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "ReceiptViewController.h"
#import "OrderTaking.h"
#import "Menu.h"
#import "OrderNote.h"
#import "OrderTakingViewController.h"
#import "Member.h"
#import "CustomCollectionViewCellReceiptOrder.h"
#import "CustomCollectionViewCellMemberDetail.h"
#import "CustomTableViewCellMemberRegister.h"
#import "CustomTableViewCellMemberRegisterSegment.h"
#import "ConfirmAndCancelView.h"

//part printer
#import "AppDelegate.h"
//#import "Communication.h"
//#import "PrinterFunctions.h"
//#import "ILocalizeReceipts.h"

@interface ReceiptViewController ()
{
    NSMutableArray *_orderTakingList;
    UITextField *_txtBirthDate;
    UITextField *_txtPhoneNo;
    UITextField *_txtFullName;
    UITextField *_txtNickName;
    UISegmentedControl *_segConGender;
    Member *_member;
}

@end

@implementation ReceiptViewController
static NSString * const reuseHeaderViewIdentifier = @"HeaderView";
static NSString * const reuseFooterViewIdentifier = @"FooterView";
static NSString * const reuseIdentifierReceiptOrder = @"CustomCollectionViewCellReceiptOrder";
static NSString * const reuseIdentifierMemberDetail = @"CustomCollectionViewCellMemberDetail";
static NSString * const reuseIdentifierMemberRegister = @"TableViewMemberRegister";
static NSString * const reuseIdentifierMemberRegisterSegment = @"TableViewMemberRegisterSegment";


@synthesize customerTable;
@synthesize txtMemberNo;
@synthesize colVwReceiptOrder;
@synthesize colVwMemberDetail;
@synthesize btnCash;
@synthesize btnCloseTable;
@synthesize btnCredeitCard;
@synthesize btnAddMoreOrder;
@synthesize btnMergeReceipt;
@synthesize btnPrintReceipt;
@synthesize btnPrintTempReceipt;
@synthesize vwTopLeft;
@synthesize vwBottom;
@synthesize vwTopMiddle;
@synthesize lblMemberNo;
@synthesize lblTableName;
@synthesize lblFoodAndBeverageFigure;
@synthesize lblVatFigure;
@synthesize lblNetTotalFigure;
@synthesize lblOtherDiscountFigure;
@synthesize lblServiceChargeFigure;
@synthesize lblFoodDiscountFigure;
@synthesize tbvMemberRegister;
@synthesize vwConfirmAndCancel;
@synthesize dtPicker;

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
        Member *member = [Member getMemberWithPhoneNo:[Utility trimString:textField.text]];
        
        
        //reload member detail
        _member = member;
        [colVwMemberDetail reloadData];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    if([textField isEqual:_txtBirthDate])
    {
        [self closeMemberRegisterBox];
        
        
        NSString *strDate = textField.text;
        if([strDate isEqualToString:@""])
        {
            NSInteger year = [[Utility dateToString:[NSDate date] toFormat:@"yyyy"] integerValue]-1;
            NSString *strDefaultDate = [NSString stringWithFormat:@"1 Jan %ld",year-20];
            NSDate *datePeriod = [Utility stringToDate:strDefaultDate fromFormat:@"d MMM yyyy"];
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
    if([_txtBirthDate isFirstResponder])
    {
        _txtBirthDate.text = [Utility dateToString:dtPicker.date toFormat:@"d MMM yyyy"];
    }
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    


    
    {
        CGRect frame = colVwReceiptOrder.frame;
        frame.size.width = self.view.frame.size.width*0.4;
        colVwReceiptOrder.frame = frame;
    }
    
    {
        CGRect frame = colVwMemberDetail.frame;
        frame.origin.x = self.view.frame.size.width*0.4 + 8;
        frame.size.width = self.view.frame.size.width*0.6-145-29-8;
        colVwMemberDetail.frame = frame;
    }
    
    {
        CGRect frame = vwTopLeft.frame;
        frame.size.width = self.view.frame.size.width*0.4;
        vwTopLeft.frame = frame;
    }
    
    {
        CGRect frame = vwBottom.frame;
        frame.size.width = self.view.frame.size.width*0.4 + 3;
        vwBottom.frame = frame;
    }
    
    {
        CGRect frame = vwTopMiddle.frame;
        frame.origin.x = self.view.frame.size.width*0.4 + 8;
        frame.size.width = colVwMemberDetail.frame.size.width;
        vwTopMiddle.frame = frame;
    }
    
    {
        CGRect frame = lblMemberNo.frame;
        frame.origin.x = self.view.frame.size.width*0.4 + 8;
        frame.origin.y = txtMemberNo.frame.origin.y;
        lblMemberNo.frame = frame;
    }

    {
        CGRect frame = txtMemberNo.frame;
        frame.origin.x = lblMemberNo.frame.origin.x+lblMemberNo.frame.size.width+8;
        frame.size.width = colVwMemberDetail.frame.size.width - lblMemberNo.frame.size.width - 8;
        txtMemberNo.frame = frame;
    }
    
    {
        CGRect frame = lblTableName.frame;
        frame.origin.x = 0;
        frame.size.width = self.view.frame.size.width*0.4;
        lblTableName.frame = frame;
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
    colVwReceiptOrder.delegate = self;
    colVwReceiptOrder.dataSource = self;
    colVwMemberDetail.delegate = self;
    colVwMemberDetail.dataSource = self;
    


    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];




    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierReceiptOrder bundle:nil];
        [colVwReceiptOrder registerNib:nib forCellWithReuseIdentifier:reuseIdentifierReceiptOrder];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierMemberDetail bundle:nil];
        [colVwMemberDetail registerNib:nib forCellWithReuseIdentifier:reuseIdentifierMemberDetail];
    }
    
    
    
    
    
    [[NSBundle mainBundle] loadNibNamed:@"TableViewMemberRegister" owner:self options:nil];
    
    tbvMemberRegister.delegate = self;
    tbvMemberRegister.dataSource = self;
    CGRect frame = tbvMemberRegister.frame;
    frame.size.width = 350;
    frame.size.height = 264;
    tbvMemberRegister.frame = frame;
    tbvMemberRegister.backgroundColor = [UIColor whiteColor];
    [self setShadow:tbvMemberRegister radius:8];
    
    
    
//    //add header to member register
//    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0,0, tbvMemberRegister.frame.size.width, 40)];
//    headerView.backgroundColor = [UIColor whiteColor];
//    tbvMemberRegister.tableHeaderView = headerView;
//    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0,12, 160, 25)];
//    title.text = @"   สมัครสมาชิก";
//    title.textColor = [UIColor blackColor];
//    title.font = [UIFont boldSystemFontOfSize:14.0];
//    [headerView addSubview:title];
//    
    
    
    
    
    
    
    {
        UINib *nib = [UINib nibWithNibName:@"CustomTableViewCellMemberRegister" bundle:nil];
        [tbvMemberRegister registerNib:nib forCellReuseIdentifier:reuseIdentifierMemberRegister];
    }
    {
        UINib *nib = [UINib nibWithNibName:@"CustomTableViewCellMemberRegisterSegment" bundle:nil];
        [tbvMemberRegister registerNib:nib forCellReuseIdentifier:reuseIdentifierMemberRegisterSegment];
    }
    
    
    
    //add ยืนยัน กับ ยกเลิก button
    [[NSBundle mainBundle] loadNibNamed:@"ConfirmAndCancelView" owner:self options:nil];
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0,0, tbvMemberRegister.frame.size.width, 44)];
    footerView.backgroundColor = [UIColor whiteColor];
    tbvMemberRegister.tableFooterView = vwConfirmAndCancel;
    [vwConfirmAndCancel.btnConfirm addTarget:self action:@selector(confirmRegister:) forControlEvents:UIControlEventTouchUpInside];
    [vwConfirmAndCancel.btnCancel addTarget:self action:@selector(cancelRegister:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
    [self.tabBarController.tabBar setFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
}

- (void)loadView
{
    [super loadView];
    txtMemberNo.delegate = self;
    
    
    [self setShadow:colVwReceiptOrder];
    [self setShadow:colVwMemberDetail];
    [self setCornerAndShadow:btnCash];
    [self setCornerAndShadow:btnCloseTable];
    [self setCornerAndShadow:btnCredeitCard];
    [self setCornerAndShadow:btnAddMoreOrder];
    [self setCornerAndShadow:btnMergeReceipt];
    [self setCornerAndShadow:btnPrintReceipt];
    [self setCornerAndShadow:btnPrintTempReceipt];
    
    
    
    
    
    
    
    
    
    [dtPicker removeFromSuperview];
    
    
    
    
    
    
    [self loadViewProcess];
}

- (void)loadViewProcess
{
    //จัดเรียงก่อน แล้วถึงเซ็ตค่าเข้า _ordertakingList
    _orderTakingList = [OrderTaking getOrderTakingListWithCustomerTableID:customerTable.customerTableID status:2];
    [self reaarangeOrderWithUpdateOrderTakingListInDB:YES];//มี remove ค่าออกจาก SharedOrder ไม่ได้เอาออกจาก _ordertakingList โดยตรงจึงให้เรียก getordertakinglist ใหม่
    _orderTakingList = [OrderTaking getOrderTakingListWithCustomerTableID:customerTable.customerTableID status:2];
    
    
    
    //order by orderno (orderno = 0 put at the back)
    for(OrderTaking *item in _orderTakingList)
    {
        Menu *menu = [Menu getMenu:item.menuID];
        item.menuOrderNo = menu.orderNo;
    }
    
    NSMutableArray *rearrangeOrderTakingList = [[NSMutableArray alloc]init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_orderNo != 0"];
    NSArray *filterArray = [_orderTakingList filteredArrayUsingPredicate:predicate];
    
    
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"_orderNo" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor1,nil];
    NSArray *sortArray = [filterArray sortedArrayUsingDescriptors:sortDescriptors];
    rearrangeOrderTakingList = [sortArray mutableCopy];
    
    
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"_orderNo = 0"];
    NSArray *filterArray2 = [_orderTakingList filteredArrayUsingPredicate:predicate2];
    [rearrangeOrderTakingList addObjectsFromArray:filterArray2];
    _orderTakingList = rearrangeOrderTakingList;
    
    
    lblTableName.text = [NSString stringWithFormat:@"รายการอาหารและเครื่องดื่มโต๊ะ %@",customerTable.tableName];
    [self updateTotalOrderAndAmount];
}

- (void)updateTotalOrderAndAmount
{
    float totalAmount = [OrderTaking getTotalAmount:_orderTakingList];
    float foodDiscount = 0;
    float otherDiscount = 0;
    float serviceCharge = totalAmount*0.1;
    float vat = (totalAmount + serviceCharge) * 0.07;
    float netTotal = totalAmount + serviceCharge + vat;
    
    NSString *strTotalAmount = [Utility formatDecimal:totalAmount withMinFraction:2 andMaxFraction:2];
    NSString *strFoodDiscount = [Utility formatDecimal:foodDiscount withMinFraction:2 andMaxFraction:2];
    NSString *strOtherDiscount = [Utility formatDecimal:otherDiscount withMinFraction:2 andMaxFraction:2];
    NSString *strServiceCharge = [Utility formatDecimal:serviceCharge withMinFraction:2 andMaxFraction:2];
    NSString *strVat = [Utility formatDecimal:vat withMinFraction:2 andMaxFraction:2];
    NSString *strNetTotal = [Utility formatDecimal:netTotal withMinFraction:2 andMaxFraction:2];
    
    
    lblFoodAndBeverageFigure.text = [NSString stringWithFormat:@"฿%@",strTotalAmount];
    lblFoodDiscountFigure.text = [NSString stringWithFormat:@"฿%@",strFoodDiscount];
    lblOtherDiscountFigure.text = [NSString stringWithFormat:@"฿%@",strOtherDiscount];
    lblServiceChargeFigure.text = [NSString stringWithFormat:@"฿%@",strServiceCharge];
    lblVatFigure.text = [NSString stringWithFormat:@"฿%@",strVat];
    lblNetTotalFigure.text = [NSString stringWithFormat:@"฿%@",strNetTotal];
}

- (void)reaarangeOrderWithUpdateOrderTakingListInDB:(BOOL)update
{
    if([_orderTakingList count] == 0)
    {
        return;
    }
    for(OrderTaking *item in _orderTakingList)
    {
        Menu *menu = [Menu getMenu:item.menuID];
        item.menuOrderNo = menu.orderNo;
    }
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"_takeAway" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"_menuOrderNo" ascending:YES];
    NSSortDescriptor *sortDescriptor3 = [[NSSortDescriptor alloc] initWithKey:@"_noteIDListInText" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor1,sortDescriptor2,sortDescriptor3,nil];
    NSArray *sortArray = [_orderTakingList sortedArrayUsingDescriptors:sortDescriptors];
    
    
    NSMutableArray *rearrangeList = [[NSMutableArray alloc]init];
    NSMutableArray *removeList = [[NSMutableArray alloc]init];
    NSMutableArray *updateList = [[NSMutableArray alloc]init];
    NSMutableArray *reservedList = [[NSMutableArray alloc]init];
    NSMutableArray *checkedIDInsertedList = [[NSMutableArray alloc]init];
    
    int i = 0;
    int j = 0;
    NSInteger previousTakeAway = -1;
    NSInteger previousMenuOrderNo = -1;
    NSString *previousNoteIDListInText = @"-";
    for(OrderTaking *item in sortArray)
    {
        if(i == 0)
        {
            [reservedList addObject:item];
            previousTakeAway = item.takeAway;
            previousMenuOrderNo = item.menuOrderNo;
            previousNoteIDListInText = item.noteIDListInText;
            j++;
        }
        else
        {
            //เช็คว่าซ้ำกับตัวก่อนหน้าหรือไม่ ถ่้าไม่ซ้ำทำด้านล่าง
            if(item.takeAway != previousTakeAway || item.menuOrderNo != previousMenuOrderNo || ![item.noteIDListInText isEqualToString:previousNoteIDListInText])
            {
                //ถ้า มี record ที่ซ้ำกัน ด้วย take away, menu, note ให้ รวม quantity แล้วเตรียมข้อมูลไว้ อัพเดตลงใน checkIDInsertedList,updateList เพื่อนำไป update ภายหลัง
                if(j>1)
                {
                    float sumQuantity = 0;
                    for(OrderTaking *itemReserved in reservedList)
                    {
                        sumQuantity += itemReserved.quantity;
                    }
                    OrderTaking *orderTakingCheckIDInserted = (OrderTaking*)[reservedList[0] copy];
                    orderTakingCheckIDInserted.quantity = sumQuantity;
                    [checkedIDInsertedList addObject:orderTakingCheckIDInserted];
                    [updateList addObject:reservedList[0]];
                    
                    
                    for(int j=1; j<[reservedList count]; j++)
                    {
                        [removeList addObject:reservedList[j]];
                    }
                }
                
                [rearrangeList addObject:reservedList[0]];
                [reservedList removeAllObjects];
                j = 1;
            }
            else //ถ้าซ้ำกับตัวก่อนหน้า
            {
                j++;
            }
            [reservedList addObject:item];
            previousTakeAway = item.takeAway;
            previousMenuOrderNo = item.menuOrderNo;
            previousNoteIDListInText = item.noteIDListInText;
        }
        
        i++;
    }
    //สำหรับตัวสุดท้าย
    if(j>1)
    {
        float sumQuantity = 0;
        for(OrderTaking *itemReserved in reservedList)
        {
            sumQuantity += itemReserved.quantity;
        }
        OrderTaking *orderTakingCheckIDInserted = (OrderTaking*)[reservedList[0] copy];
        orderTakingCheckIDInserted.quantity = sumQuantity;
        [checkedIDInsertedList addObject:orderTakingCheckIDInserted];
        
        
        
        for(int j=1; j<[reservedList count]; j++)
        {
            [removeList addObject:reservedList[j]];
        }
        
        [updateList addObject:reservedList[0]];
    }
    
    [rearrangeList addObject:reservedList[0]];
    [reservedList removeAllObjects];
    
    
    
    
    //check idinserted before change value
    for(OrderTaking *item in _orderTakingList)
    {
        if(!item.idInserted)
        {
            [self showAlertAndCallPushSync:@"" message:@"ไม่สามารถจัดเรียงใหม่ได้ กรุณาลองใหม่อีกครั้ง"];
            return;
        }
    }
    
    //remove ordertaking and also ordernote
    if([removeList count]>0)
    {
        NSMutableArray *allOrderNoteList = [[NSMutableArray alloc]init];
        for(OrderTaking *item in removeList)
        {
            NSMutableArray *orderNoteList = [OrderNote getOrderNoteListWithOrderTakingID:item.orderTakingID];
            [allOrderNoteList addObjectsFromArray:orderNoteList];
        }
        [OrderNote removeList:allOrderNoteList];
        [self.homeModel deleteItems:dbOrderNoteList withData:allOrderNoteList actionScreen:@"Remove ordernote in rearrange in order taking screen"];
        [OrderTaking removeList:removeList];
        [self.homeModel deleteItems:dbOrderTakingList withData:removeList actionScreen:@"Remove ordertaking in rearrange in order taking screen"];
    }
    for(OrderTaking *item in checkedIDInsertedList)
    {
        for(OrderTaking *itemUpdate in updateList)
        {
            if(item.orderTakingID == itemUpdate.orderTakingID)
            {
                itemUpdate.quantity = item.quantity;
                itemUpdate.modifiedUser = [Utility modifiedUser];
                itemUpdate.modifiedDate = [Utility currentDateTime];
                break;
            }
        }
    }
    [checkedIDInsertedList removeAllObjects];
    
    //input orderNo
    int k = 1;
    for(OrderTaking *item in rearrangeList)
    {
        item.orderNo = k;
        item.modifiedUser = [Utility modifiedUser];
        item.modifiedDate = [Utility currentDateTime];
        k++;
    }
    
    
    //reaarange list includes change quantity and input order no
    if(update)
    {
        [self.homeModel updateItems:dbOrderTakingList withData:rearrangeList actionScreen:@"Update part in rearrange in order taking screen"];
    }
}
    
- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToCustomerTable" sender:self];
}

- (IBAction)addMoreOrder:(id)sender
{
    [self performSegueWithIdentifier:@"segOrderTaking" sender:self];
}

- (IBAction)registerMember:(id)sender
{
    //show note box to select
    tbvMemberRegister.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segOrderTaking"])
    {
        OrderTakingViewController *vc = segue.destinationViewController;
        vc.customerTable = customerTable;
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return  1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if([collectionView isEqual:colVwReceiptOrder])
    {
        //load order มาโชว์
        return [_orderTakingList count];
    }
    else if([collectionView isEqual:colVwMemberDetail])
    {
        return 5;
    }
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSInteger item = indexPath.item;
    if([collectionView isEqual:colVwReceiptOrder])
    {
        CustomCollectionViewCellReceiptOrder *cell = (CustomCollectionViewCellReceiptOrder*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierReceiptOrder forIndexPath:indexPath];
        
        
        cell.contentView.userInteractionEnabled = NO;
        
        
        //menu name
        OrderTaking *orderTaking = _orderTakingList[item];
        Menu *menu = [Menu getMenu:orderTaking.menuID];
        if(orderTaking.takeAway)
        {
            UIFont *font = [UIFont systemFontOfSize:14];
            NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"ใส่ห่อ"
                                                                                           attributes:attribute];
            
            NSDictionary *attribute2 = @{NSFontAttributeName: font};
            NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",menu.titleThai] attributes:attribute2];
            
            
            [attrString appendAttributedString:attrString2];
            cell.lblMenuName.attributedText = attrString;
        }
        else
        {
            cell.lblMenuName.text = menu.titleThai;
        }
        
        
        CGSize menuNameLabelSize = [self suggestedSizeWithFont:cell.lblMenuName.font size:CGSizeMake(self.view.frame.size.width - (375 - (243 - 8) - 16), CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:cell.lblMenuName.text];//153 from storyboard
        CGRect frame = cell.lblMenuName.frame;
        frame.size.width = menuNameLabelSize.width;
        frame.size.height = menuNameLabelSize.height;
        cell.lblMenuName.frame = frame;
        
        
        
        //note
        cell.lblNote.text = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID];
        
        
        
        CGSize noteLabelSize = [self suggestedSizeWithFont:cell.lblNote.font size:CGSizeMake(colVwReceiptOrder.frame.size.width - (375 - (243 - 8) - 16), CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:cell.lblNote.text];
        CGRect frame2 = cell.lblNote.frame;
        frame2.size.width = noteLabelSize.width;
        frame2.size.height = noteLabelSize.height;
        cell.lblNote.frame = frame2;
        
        
        
        //total price
        NSString *strTotalPrice = [Utility formatDecimal:orderTaking.quantity*orderTaking.price withMinFraction:2 andMaxFraction:2];
        cell.lblTotalPrice.text = [NSString stringWithFormat:@"฿%@",strTotalPrice];
        
        
        //quantity
        NSString *strQuantity = [Utility formatDecimal:orderTaking.quantity withMinFraction:0 andMaxFraction:0];
        cell.lblQuantity.text = strQuantity;
        
        
        
        return cell;
    }
    else if([collectionView isEqual:colVwMemberDetail])
    {
        CustomCollectionViewCellMemberDetail *cell = (CustomCollectionViewCellMemberDetail*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierMemberDetail forIndexPath:indexPath];
        
        
        cell.contentView.userInteractionEnabled = NO;
        
        if(_member)
        {
            switch (item) {
                case 0:
                {
                    cell.lblTitle.text = @"ชื่อ";
                    cell.lblValue.text = _member.fullName;
                }
                break;
                case 1:
                {
                    cell.lblTitle.text = @"ชื่อเล่น";
                    cell.lblValue.text = _member.nickname;
                }
                break;
                case 2:
                {
                    cell.lblTitle.text = @"เบอร์โทร";
                    cell.lblValue.text = _member.phoneNo;
                }
                break;
                case 3:
                {
                    cell.lblTitle.text = @"วันเกิด";
//                    cell.lblValue.text = [Utility dateToString:_member.birthDate toFormat:@"d MMM yyyy"];
                    cell.lblValue.text = [Utility formatDate:[NSString stringWithFormat:@"%@",_member.birthDate] fromFormat:@"yyyy-MM-dd HH:mm:ss" toFormat:@"d MMM yyyy"];
                }
                break;
                case 4:
                {
                    cell.lblTitle.text = @"เพศ";
                    cell.lblValue.text = _member.gender;
                }
                break;
                
                default:
                break;
            }
        }
        else
        {
            switch (item) {
                case 0:
                {
                    cell.lblTitle.text = @"ชื่อ";
                    cell.lblValue.text = @"";
                }
                break;
                case 1:
                {
                    cell.lblTitle.text = @"ชื่อเล่น";
                    cell.lblValue.text = @"";
                }
                break;
                case 2:
                {
                    cell.lblTitle.text = @"เบอร์โทร";
                    cell.lblValue.text = @"";
                }
                break;
                case 3:
                {
                    cell.lblTitle.text = @"วันเกิด";
                    cell.lblValue.text = @"";
                }
                break;
                case 4:
                {
                    cell.lblTitle.text = @"เพศ";
                    cell.lblValue.text = @"";
                }
                break;
                
                default:
                break;
            }
        }
        return cell;
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
- (CGSize)suggestedSizeWithFont:(UIFont *)font size:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode forString:(NSString *)text {
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = lineBreakMode;
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: font,       NSParagraphStyleAttributeName: paragraphStyle}];
    CGRect bounds = [attributedString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return bounds.size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeMake(0, 0);
    NSInteger item = indexPath.item;
    if([collectionView isEqual:colVwReceiptOrder])
    {
        //load order มาโชว์
        OrderTaking *orderTaking = _orderTakingList[item];
        Menu *menu = [Menu getMenu:orderTaking.menuID];
        
        NSString *strMenuName;
        if(orderTaking.takeAway)
        {
            strMenuName = [NSString stringWithFormat:@"ใส่ห่อ %@",menu.titleThai];
        }
        else
        {
            strMenuName = menu.titleThai;
        }
        
        
        UIFont *fontMenuName = [UIFont systemFontOfSize:14.0];
        UIFont *fontNote = [UIFont systemFontOfSize:11.0];
        
        
        CGSize menuNameLabelSize = [self suggestedSizeWithFont:fontMenuName size:CGSizeMake(colVwReceiptOrder.frame.size.width - (375 - (243 - 8) - 16), CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:strMenuName];//153 from storyboard
        CGSize noteLabelSize = [self suggestedSizeWithFont:fontNote size:CGSizeMake(colVwReceiptOrder.frame.size.width - (375 - (243 - 8) - 16), CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:[OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID]];
        
        
        float height = menuNameLabelSize.height+noteLabelSize.height+10*2;
        size = CGSizeMake(colVwReceiptOrder.frame.size.width,height);
    }
    else if([collectionView isEqual:colVwMemberDetail])
    {
        if(!_member)
        {
            size = CGSizeMake(colVwMemberDetail.frame.size.width,44);
            return size;
        }
        //load member มาโชว์
        NSString *strValue = @"";
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
//                strValue = [Utility dateToString:_member.birthDate toFormat:@"d MMM yyyy"];
                strValue = [Utility formatDate:[NSString stringWithFormat:@"%@",_member.birthDate] fromFormat:@"yyyy-MM-dd HH:mm:ss" toFormat:@"d MMM yyyy"];
            }
            break;
            case 4:
            {
                strValue = _member.gender;
            }
            break;
            default:
            break;
        }
        
    
        
        UIFont *font = [UIFont systemFontOfSize:14.0];
        CGSize labelSize = [self suggestedSizeWithFont:font size:CGSizeMake(colVwMemberDetail.frame.size.width - 16 - 60 - 8, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:strValue];
        
        
        float height = labelSize.height+15*2;
        size = CGSizeMake(colVwMemberDetail.frame.size.width,height);
    }
    
    
    return size;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)colVwReceiptOrder.collectionViewLayout;
        
        [layout invalidateLayout];
        [colVwReceiptOrder reloadData];
    }
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
        CustomTableViewCellMemberRegister *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierMemberRegister];
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (item) {
            case 0:
            {
                cell.lblTitle.text = @"ชื่อ";
                _txtFullName = cell.txtValue;
            }
            break;
            case 1:
            {
                cell.lblTitle.text = @"ชื่อเล่น";
                _txtNickName = cell.txtValue;
            }
            break;
            case 2:
            {
                cell.lblTitle.text = @"เบอร์โทร";
                _txtPhoneNo = cell.txtValue;
            }
            break;
            case 3:
            {
                cell.lblTitle.text = @"วันเกิด";
                _txtBirthDate = cell.txtValue;
                
                
                _txtBirthDate.inputView = dtPicker;
                _txtBirthDate.delegate = self;
                _txtBirthDate.text = @"";
            }
            break;
            default:
            break;
        }
        
        return cell;
    }
    else if(item == 4)
    {
        CustomTableViewCellMemberRegisterSegment *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierMemberRegisterSegment];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _segConGender = cell.segConGender;
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
    cell.backgroundColor = [UIColor whiteColor];
    [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
    
}

- (void)confirmRegister:(id)sender
{
    if(![self validateMemberRegister])
    {
        return;
    }
    
    NSString *fullName = [Utility trimString:_txtFullName.text];
    NSString *nickName = [Utility trimString:_txtNickName.text];
    NSString *phoneNo = [Utility trimString:_txtPhoneNo.text];
    NSDate *birthDate = [Utility stringToDate:_txtBirthDate.text fromFormat:@"d MMM yyyy"];
    NSString *gender = _segConGender.selectedSegmentIndex == 0?@"M":_segConGender.selectedSegmentIndex == 1?@"F":@"N";
    
    
    //insert
    Member *member = [[Member alloc]initWithFullName:fullName nickname:nickName phoneNo:phoneNo birthDate:birthDate gender:gender];
    [Member addObject:member];
    [self.homeModel insertItems:dbMember withData:member actionScreen:@"Insert member in receipt screen"];
    [self showAlert:@"" message:@"สมัครสมาชิกสำเร็จ"];
    [self closeMemberRegisterBoxAndClearData];
    
}

- (void)cancelRegister:(id)sender
{
    [self closeMemberRegisterBoxAndClearData];
    
   
}

- (BOOL)validateMemberRegister
{
    //require phone on
    if([Utility isStringEmpty:_txtPhoneNo.text])
    {
        [self showAlert:@"" message:@"กรุณาใส่หมายเลขโทรศัพท์"];
        return NO;
    }
    
    
    
    //check phoneno exist
    Member *member = [Member getMemberWithPhoneNo:_txtPhoneNo.text];
    if(member)
    {
        [self showAlert:@"" message:@"สมาชิกนี้มีอยู่แล้ว"];
        return NO;
    }
    return YES;
}

- (void)closeMemberRegisterBoxAndClearData
{
    //clear value
    _txtFullName.text = @"";
    _txtNickName.text = @"";
    _txtPhoneNo.text = @"";
    _txtBirthDate.text = @"";
    _segConGender.selectedSegmentIndex = 0;
    [tbvMemberRegister removeFromSuperview];
}

- (void)closeMemberRegisterBox
{
    [tbvMemberRegister removeFromSuperview];
}
@end
