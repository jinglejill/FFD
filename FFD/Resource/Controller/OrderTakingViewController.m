//
//  OrderTakingViewController.m
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/6/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "OrderTakingViewController.h"
#import "NoteViewController.h"
#import "CustomCollectionViewCellOrderAdjust.h"
#import "CustomCollectionViewCellTabMenuType.h"
#import "CustomCollectionViewCellMenuWithTakeAway.h"
#import "CustomCollectionReusableView.h"
#import "MenuType.h"
#import "Menu.h"
#import "TableTaking.h"
#import "OrderTaking.h"
#import "MenuTypeNote.h"
#import "Note.h"
#import "OrderNote.h"
#import "OrderKitchen.h"
#import "SubMenuType.h"
#import "Receipt.h"
#import "SpecialPriceProgram.h"
#import "Setting.h"
#import "Printer.h"
#import "MoneyCheck.h"
#import "InvoiceComposer.h"
//#import "CustomPrintPageRenderer.h"



//part printer
#import "AppDelegate.h"
#import "Communication.h"
#import "PrinterFunctions.h"
#import "ILocalizeReceipts.h"


@interface OrderTakingViewController ()
{
    NSMutableArray *_menuTypeList;
    NSMutableArray *_subMenuTypeList;
    NSMutableArray *_arrOfmenuList;
    NSMutableArray *_emptyMenuList;
    NSMutableArray *_orderTakingList;
    NSInteger _selectedIndexMenuType;
    NSMutableArray *_noteList;
    NSInteger _selectedOrderAdjustItem;
    UIColor *_blinkColor;
    NSMutableArray *_webViewList;
    UIView *_backgroundView;
    NSMutableArray *_arrOfHtmlContentList;
    NSInteger _countPrint;
    NSInteger _countingPrint;
    NSMutableDictionary *_printBillWithPortName;
    UIPopoverPresentationController *_notePopController;
    
}
@end

@implementation OrderTakingViewController
static NSString * const reuseHeaderViewIdentifier = @"CustomCollectionReusableView";
static NSString * const reuseFooterViewIdentifier = @"FooterView";
static NSString * const reuseIdentifierOrderAdjust = @"CustomCollectionViewCellOrderAdjust";
static NSString * const reuseIdentifierOrderTabMenuType = @"CustomCollectionViewCellTabMenuType";
static NSString * const reuseIdentifierMenuWithTakeAway = @"CustomCollectionViewCellMenuWithTakeAway";


@synthesize customerTable;
@synthesize lblTableName;
@synthesize lblServingPerson;
@synthesize txtTableName;
@synthesize txtServingPerson;
@synthesize colVwOrderAdjust;
@synthesize lblTotalOrder;
@synthesize lblTotalOrderFigure;
@synthesize lblTotalAmount;
@synthesize lblTotalAmountFigure;
@synthesize lblServiceAndVat;
@synthesize btnMoveToTrashAll;
@synthesize btnSendToKitchen;
@synthesize colVwTabMenuType;
@synthesize colVwMenuWithTakeAway;
@synthesize btnRearrange;
@synthesize vwBottomLabelAndButton;
@synthesize vwTableNameAndServingPerson;


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //จัดการกับ จำนวนลูกค้า
    if([textField isEqual:txtServingPerson])
    {
        //กรณีลบค่า
        if([[Utility trimString:textField.text] isEqualToString:@""])
        {
            NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithCustomerTableID:customerTable.customerTableID statusList:@[@2,@3]];
            if([orderTakingList count]>0)
            {
                TableTaking *tableTakingExist = [TableTaking getTableTakingWithCustomerTableID:customerTable.customerTableID receiptID:0];
                if(tableTakingExist)
                {
                    [self showAlert:@"" message:@"มีการสั่งอาหารไปแล้ว ไม่สามารถลบจำนวนลูกค้าได้"];
                    textField.text = [NSString stringWithFormat:@"%ld",tableTakingExist.servingPerson];
                }
            }
            else
            {
                //delete
                TableTaking *tableTakingExist = [TableTaking getTableTakingWithCustomerTableID:customerTable.customerTableID receiptID:0];
                if(tableTakingExist)
                {
                    //delete
                    [TableTaking removeObject:tableTakingExist];
                }
            }
        }
        else if(![Utility isNumeric:textField.text])//เช็คว่าต้องใส่ตัวเลขเท่านั้น
        {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                           message:@"กรุณาใส่ตัวเลขเท่านั้น"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action)
                                            {
                                                [textField becomeFirstResponder];
                                            }];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            //insert or update tabletaking
            TableTaking *tableTakingExist = [TableTaking getTableTakingWithCustomerTableID:customerTable.customerTableID receiptID:0];
            if(tableTakingExist)
            {
                //update
                tableTakingExist.servingPerson = [txtServingPerson.text integerValue];
                tableTakingExist.modifiedUser = [Utility modifiedUser];
                tableTakingExist.modifiedDate = [Utility currentDateTime];
            }
            else
            {
                //insert
                TableTaking *tableTaking = [[TableTaking alloc]initWithCustomerTableID:customerTable.customerTableID servingPerson:[txtServingPerson.text integerValue] receiptID:0];
                [TableTaking addObject:tableTaking];
            }
        }
    }
    else if([textField isEqual:txtTableName])
    {
        //validate table name
        CustomerTable *customerTableEnter = [CustomerTable getCustomerTableWithTableName:txtTableName.text status:1];
        if(customerTableEnter)
        {
            customerTable = customerTableEnter;
            [self loadViewProcess];
        }
        else
        {
            txtTableName.text = customerTable.tableName;
        }
    }
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    
    // Now modify bottomView's frame here
    {
        CGRect frame = lblTableName.frame;
        frame.origin.x = self.view.frame.size.width/3/2-frame.size.width;
        lblTableName.frame = frame;
    }
    
    {
        CGRect frame = lblServingPerson.frame;
        frame.origin.x = self.view.frame.size.width/3/2-frame.size.width;
        lblServingPerson.frame = frame;
    }
    
    
    {
        CGRect frame = txtTableName.frame;
        frame.origin.x = lblTableName.frame.origin.x + lblTableName.frame.size.width + 8;
        txtTableName.frame = frame;
    }
    
    {
        CGRect frame = txtServingPerson.frame;
        frame.origin.x = lblTableName.frame.origin.x + lblTableName.frame.size.width + 8;
        txtServingPerson.frame = frame;
    }
    
    {
        CGRect frame = colVwOrderAdjust.frame;
        
        frame.origin.x = 0;
        frame.origin.y = txtServingPerson.frame.origin.y + txtServingPerson.frame.size.height + 8;
        frame.size.width = self.view.frame.size.width/3;
        frame.size.height = self.view.frame.size.height - frame.origin.y - 187;//187 มาจากตำแหน่งใน storyboard โดยลบข้อมูลด้านล่างออก lbl จำนวนรายการ y = 599, space ถึง colvwOrderAdjust.bottom 18 , height of self.view 768 --> 768 - (599-18) = 187
        colVwOrderAdjust.frame = frame;
    }
    
    {
        CGRect frame = btnMoveToTrashAll.frame;
        frame.size.width = (self.view.frame.size.width/3-8*2)/2;
        btnMoveToTrashAll.frame = frame;
        [self setImageAndTitleCenter:btnMoveToTrashAll];
        
    }
    {
        CGRect frame = btnSendToKitchen.frame;
        frame.size.width = (self.view.frame.size.width/3-8*2)/2;
        frame.origin.x = frame.size.width + 8*2;
        btnSendToKitchen.frame = frame;
        [self setImageAndTitleCenter:btnSendToKitchen];
    }
    
    {
        CGRect frame = colVwTabMenuType.frame;
        
        frame.origin.x = self.view.frame.size.width/3+8;
        frame.origin.y = 20;//ให้ถัดจาก top status bar
        frame.size.width = self.view.frame.size.width/3*2-8;
        frame.size.height = 91-20-2;//storyboard reference
        colVwTabMenuType.frame = frame;
    }
    
    {
        CGRect frame = colVwMenuWithTakeAway.frame;
        
        frame.origin.x = self.view.frame.size.width/3+8;
        frame.origin.y = 91+8;//storyboard reference+gap
        frame.size.width = self.view.frame.size.width/3*2-8;
        frame.size.height = self.view.frame.size.height-91-8;//storyboard reference
        colVwMenuWithTakeAway.frame = frame;
    }
    
    {
        CGRect frame = btnRearrange.frame;
        frame.origin.x = colVwMenuWithTakeAway.frame.origin.x - 8 - frame.size.width;
        btnRearrange.frame = frame;
    }
    
    {
        CGRect frame = vwBottomLabelAndButton.frame;
        frame.size.width = colVwOrderAdjust.frame.size.width;
        frame.origin.y = colVwOrderAdjust.frame.origin.y + colVwOrderAdjust.frame.size.height;
        frame.size.height = self.view.frame.size.height - colVwOrderAdjust.frame.origin.y - colVwOrderAdjust.frame.size.height;
        vwBottomLabelAndButton.frame = frame;
    }
    
    
    {
        CGRect frame = vwTableNameAndServingPerson.frame;
        frame.size.width = self.view.frame.size.width;//colVwOrderAdjust.frame.size.width;
        
        vwTableNameAndServingPerson.frame = frame;
    }
    
    
    {
//    take away
//menu list
        NSInteger numberOfSection = [_subMenuTypeList count];
        for(int i=0; i<numberOfSection; i++)
        {
            NSMutableArray *menuList = _arrOfmenuList[i];
            NSInteger numberOfItem = [menuList count];
            for(int j=0; j<numberOfItem; j++)
            {
                Menu *menu = menuList[j];
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
                CustomCollectionViewCellMenuWithTakeAway *cell = (CustomCollectionViewCellMenuWithTakeAway *)[colVwMenuWithTakeAway cellForItemAtIndexPath:indexPath];
                
                
                
                UIColor *color = UIColorFromRGB([Utility hexStringToInt:menu.color]);
                cell.backgroundColor = color;
                [self makeBottomRightRoundedCorner:cell.vwRoundedCorner];
            }
        }
    }
    
    {
        CGRect frame = _backgroundView.frame;
        frame = self.view.frame;
        _backgroundView.frame = frame;
    }
}

- (void)loadView
{
    [super loadView];
    [self setCurrentVc];
    
    
    txtServingPerson.delegate = self;
    txtTableName.delegate = self;
    _blinkColor = [UIColor clearColor];
    _selectedOrderAdjustItem = -1;
    _selectedIndexMenuType = 0;
    _arrOfmenuList = [[NSMutableArray alloc]init];
    _emptyMenuList = [[NSMutableArray alloc]init];

    
    
    //use webview for calculate pdf page size
    _backgroundView = [[UIView alloc]initWithFrame:self.view.frame];
    _backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:_backgroundView atIndex:0];
    _webViewList = [[NSMutableArray alloc]init];
    
    
    
    //check idinserted ครั้งเดียวตอนโหลด สำหรับตอนกด back แล้วเข้ามาใหม่
    NSMutableArray *idInsertedOrderTakingList = [OrderTaking getOrderTakingListWithCustomerTableID:customerTable.customerTableID status:1];
    if([idInsertedOrderTakingList count]>0)
    {
        if(![OrderTaking checkIdInserted:idInsertedOrderTakingList])
        {
            [self loadingOverlayView];
        }
    }
    
    
    
    //sendToKitchen button
    NSInteger period = [self inPeriod:1]?1:[self inPeriod:2]?2:[self inPeriod:3]?3:0;
    NSString *strKeyNameOpen = [NSString stringWithFormat:@"shift%ldOpenTime",period];
    NSString *strKeyNameClose = [NSString stringWithFormat:@"shift%ldCloseTime",period];
    
    NSString *strShiftOpenTime = [Setting getSettingValueWithKeyName:strKeyNameOpen];
    NSString *strShiftCloseTime = [Setting getSettingValueWithKeyName:strKeyNameClose];
    
    NSInteger intShiftOpenTime = [[strShiftOpenTime stringByReplacingOccurrencesOfString:@":" withString:@""] integerValue];
    NSInteger intShiftCloseTime = [[strShiftCloseTime stringByReplacingOccurrencesOfString:@":" withString:@""] integerValue];
    NSDate *dtShiftOpenTime;
    NSDate *dtShiftCloseTime;
    NSDate *dtShiftOpenTimeMinus30Min;
    NSDate *dtStartNextDay;
    if(intShiftOpenTime <= intShiftCloseTime)
    {
        NSString *strToday = [Utility dateToString:[Utility currentDateTime] toFormat:@"yyyy/MM/dd"];
        dtShiftOpenTime = [Utility stringToDate:[NSString stringWithFormat:@"%@ %@",strToday,strShiftOpenTime] fromFormat:@"yyyy/MM/dd HH:mm"];
        dtShiftCloseTime = [Utility stringToDate:[NSString stringWithFormat:@"%@ %@",strToday,strShiftCloseTime] fromFormat:@"yyyy/MM/dd HH:mm"];
        dtShiftOpenTimeMinus30Min = [Utility getPrevious30Min:dtShiftOpenTime];
    }
    else
    {
        NSDate *currentDate = [Utility currentDateTime];
        NSDate *nextDay = [Utility getPreviousOrNextDay:1];
        NSDate *yesterday = [Utility getPreviousOrNextDay:-1];
        NSString *strToday = [Utility dateToString:[Utility currentDateTime] toFormat:@"yyyy/MM/dd"];
        NSString *strNextDay = [Utility dateToString:nextDay toFormat:@"yyyy/MM/dd"];
        NSString *strYesterday = [Utility dateToString:yesterday toFormat:@"yyyy/MM/dd"];
        dtStartNextDay = [Utility setStartOfTheDay:nextDay];
        dtShiftOpenTime = [Utility stringToDate:[NSString stringWithFormat:@"%@ %@",strToday,strShiftOpenTime] fromFormat:@"yyyy/MM/dd HH:mm"];
        dtShiftOpenTimeMinus30Min = [Utility getPrevious30Min:dtShiftOpenTime];
        NSComparisonResult result = [dtShiftOpenTimeMinus30Min compare:currentDate];
        NSComparisonResult result2 = [currentDate compare:dtStartNextDay];
        BOOL compareResult = (result == NSOrderedAscending || result == NSOrderedSame) && (result2 == NSOrderedAscending || result2 == NSOrderedSame);
        if(compareResult)
        {
            dtShiftCloseTime = [Utility stringToDate:[NSString stringWithFormat:@"%@ %@",strNextDay,strShiftCloseTime] fromFormat:@"yyyy/MM/dd HH:mm"];
        }
        else
        {
            dtShiftOpenTime = [Utility stringToDate:[NSString stringWithFormat:@"%@ %@",strYesterday,strShiftOpenTime] fromFormat:@"yyyy/MM/dd HH:mm"];
            dtShiftOpenTimeMinus30Min = [Utility getPrevious30Min:dtShiftOpenTime];
            dtShiftCloseTime = [Utility stringToDate:[NSString stringWithFormat:@"%@ %@",strToday,strShiftCloseTime] fromFormat:@"yyyy/MM/dd HH:mm"];
        }
    }
    NSMutableArray *moneyCheckList = [MoneyCheck getMoneyCheckListWithType:1 checkDateStart:dtShiftOpenTimeMinus30Min checkDateEnd:dtShiftCloseTime];
    btnSendToKitchen.enabled = [moneyCheckList count]>0;
    
    
    
    [self setShadow:colVwOrderAdjust];
    [self setShadow:colVwMenuWithTakeAway];
    [self setButtonDesign:btnMoveToTrashAll];
    [self setButtonDesign:btnSendToKitchen];
    
    
    [self loadViewProcess];
}

- (void)loadViewProcess
{
    //customer table section
    txtTableName.text = customerTable.tableName;
    TableTaking *tableTakingExist = [TableTaking getTableTakingWithCustomerTableID:customerTable.customerTableID receiptID:0];
    if(tableTakingExist)
    {
        NSString *strServingPerson = [Utility formatDecimal:tableTakingExist.servingPerson withMinFraction:0 andMaxFraction:0];
        txtServingPerson.text = strServingPerson;
    }
    else
    {
        txtServingPerson.text = @"";
    }
    
    
    //menu section
    _menuTypeList = [MenuType getMenuTypeListWithStatus:1];
    if([_menuTypeList count]>0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        [self collectionView:colVwTabMenuType didSelectItemAtIndexPath:indexPath];
    }
    else
    {
        [_arrOfmenuList removeAllObjects];
        [_arrOfmenuList addObject:_emptyMenuList];
    }
    
    
    //order taking section
    [self reloadOrderTaking:YES];
    
}

- (void)updateTotalOrderAndAmount
{
    
    //cal and show total order and total amount
    NSString *strTotalOrder = [Utility formatDecimal:[OrderTaking getTotalQuantity:_orderTakingList] withMinFraction:0 andMaxFraction:0];
    lblTotalOrderFigure.text = strTotalOrder;
    
    
    NSString *strTotalAmount = [Utility formatDecimal:[OrderTaking getSubTotalAmount:_orderTakingList] withMinFraction:0 andMaxFraction:2];
    lblTotalAmountFigure.text = [NSString stringWithFormat:@"฿%@",strTotalAmount];
}

- (void)reloadOrderTaking:(BOOL)sort
{
    _orderTakingList = [OrderTaking getOrderTakingListWithCustomerTableID:customerTable.customerTableID status:1];
    if(sort)
    {
        _orderTakingList = [OrderTaking sortOrderTakingList:_orderTakingList];
    }
    
    
    
    [self updateTotalOrderAndAmount];
    [colVwOrderAdjust reloadData];
}

- (void) orientationChanged:(NSNotification *)note
{
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

- (void)selectMenuType
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedIndexMenuType inSection:0];
    [colVwTabMenuType selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectMenuType)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    
    
    
    // Do any additional setup after loading the view.
    colVwOrderAdjust.delegate = self;
    colVwOrderAdjust.dataSource = self;
    colVwTabMenuType.delegate = self;
    colVwTabMenuType.dataSource = self;
    colVwMenuWithTakeAway.delegate = self;
    colVwMenuWithTakeAway.dataSource = self;
    
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierOrderAdjust bundle:nil];
        [colVwOrderAdjust registerNib:nib forCellWithReuseIdentifier:reuseIdentifierOrderAdjust];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierOrderTabMenuType bundle:nil];
        [colVwTabMenuType registerNib:nib forCellWithReuseIdentifier:reuseIdentifierOrderTabMenuType];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierMenuWithTakeAway bundle:nil];
        [colVwMenuWithTakeAway registerNib:nib forCellWithReuseIdentifier:reuseIdentifierMenuWithTakeAway];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseHeaderViewIdentifier bundle:nil];
        [colVwMenuWithTakeAway registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderViewIdentifier];
    }
    
    
    [self selectMenuType];
    
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture setCancelsTouchesInView:NO];
}

- (IBAction)goBack:(id)sender
{
    NSMutableArray *orderNoteList = [OrderNote getOrderNoteListWithCustomerTableID:customerTable.customerTableID];
    NSMutableArray *orderKitchenList = [[NSMutableArray alloc]init];
    
    
    [self.homeModel insertItems:dbOrderTakingOrderNoteOrderKitchenCustomerTable withData:@[_orderTakingList,orderNoteList,orderKitchenList,customerTable] actionScreen:@"delete then insert orderTaking, orderNote, orderKitchen in orderTaking screen"];
    
    
    
    
    //tabletaking
    TableTaking *tableTaking = [TableTaking getTableTakingWithCustomerTableID:customerTable.customerTableID receiptID:0];
    if(tableTaking)
    {
        [self.homeModel insertItems:dbTableTakingInsertUpdate withData:tableTaking actionScreen:@"update if any or insert tableTaking in ordertaking screen"];
    }
    else
    {
        [self.homeModel deleteItems:dbTableTakingWithCustomerTable withData:customerTable actionScreen:@"delete tabletaking if any"];
    }
    
    
    
    [self performSegueWithIdentifier:@"segUnwindToCustomerTable" sender:self];
}

- (IBAction)moveToTrashAll:(id)sender
{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:
     [UIAlertAction actionWithTitle:@"ลบรายการทั้งหมด"
                              style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
      {
          //delete serving person
          TableTaking *tableTaking = [TableTaking getTableTakingWithCustomerTableID:customerTable.customerTableID receiptID:0];
          if(tableTaking)
          {
              txtServingPerson.text = @"";
              [TableTaking removeObject:tableTaking];
          }
          
          
          //ลบ note ทั้งหมด
          NSMutableArray *orderNoteList = [OrderNote getOrderNoteListWithCustomerTableID:customerTable.customerTableID];
          if([orderNoteList count] > 0)
          {
              [OrderNote removeList:orderNoteList];
          }
          
          
          //ลบรายการที่สั่ง
          if([_orderTakingList count] > 0)
          {
              [OrderTaking removeList:_orderTakingList];
          }
          
          
          
          [self reloadOrderTaking:YES];
      }]];
    [alert addAction:
     [UIAlertAction actionWithTitle:@"ยกเลิก"
                              style:UIAlertActionStyleCancel
                            handler:^(UIAlertAction *action) {}]];
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        [alert setModalPresentationStyle:UIModalPresentationPopover];
        
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        CGRect frame = btnMoveToTrashAll.bounds;
        frame.origin.y = frame.origin.y-15;
        popPresenter.sourceView = btnMoveToTrashAll;
        popPresenter.sourceRect = frame;
    }
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)sendToKitchen:(id)sender
{
    //validate serving person
    TableTaking *tableTakingExist = [TableTaking getTableTakingWithCustomerTableID:customerTable.customerTableID receiptID:0];
    if(tableTakingExist)
    {
        if(!tableTakingExist.servingPerson)
        {
            [self showAlert:@"" message:@"กรุณาใส่จำนวนลูกค้า"];
            return;
        }
    }
    else
    {
        [self showAlert:@"" message:@"กรุณาใส่จำนวนลูกค้า"];
        return;
    }
    
    
    
    if([_orderTakingList count] == 0)
    {
        return;
    }
    
    
    
    [self loadingOverlayView];
    [self showStatus:@""];
    
    
    
    //call rearrange first (to sum up duplicate record(remove and update ordertaking))
    [self reaarangeOrderWithUpdateOrderTakingListInDB:NO];//เพราะมา update ที่ method นี้อยู่แล้วตอนท้าย (update status of ordertaking)

    
    
    //add to orderkitchen
    //sequenceno เอาจากค่า max ของ ordertaking status = 2
    NSInteger sequenceNo = [OrderKitchen getNextSequenceNoWithCustomerTableID:customerTable.customerTableID status:2];
    NSMutableArray *orderKitchenList = [[NSMutableArray alloc]init];
    for(OrderTaking *item in _orderTakingList)
    {
        OrderKitchen *orderKitchen = [[OrderKitchen alloc]initWithCustomerTableID:customerTable.customerTableID orderTakingID:item.orderTakingID sequenceNo:sequenceNo customerTableIDOrder:0];
        [orderKitchenList addObject:orderKitchen];
        [OrderKitchen addObject:orderKitchen];
    }
    
    
    
    //insert updated ordernote
    NSMutableArray *orderNoteList = [OrderNote getOrderNoteListWithCustomerTableID:customerTable.customerTableID];
    
    
    
    //insert update ordertakinglist
    for(OrderTaking *item in _orderTakingList)
    {
        item.status = 2;
        item.modifiedUser = [Utility modifiedUser];
        item.modifiedDate = [Utility currentDateTime];
    }
    
    
    
    //insert receipt
    NSMutableArray *receiptList = [[NSMutableArray alloc]init];
    Receipt *receipt = [Receipt getReceiptWithCustomerTableID:customerTable.customerTableID status:1];
    if(!receipt)
    {
        receipt = [[Receipt alloc]initWithCustomerTableID:customerTable.customerTableID memberID:0 servingPerson:[txtServingPerson.text integerValue] customerType:customerTable.type openTableDate:[Utility currentDateTime] cashAmount:0 cashReceive:0 creditCardType:0 creditCardNo:@"" creditCardAmount:0 transferDate:[Utility notIdentifiedDate] transferAmount:0 remark:@"" discountType:0 discountAmount:0 discountReason:@"" status:1 statusRoute:@"" receiptNoID:@"" receiptNoTaxID:@"" receiptDate:[Utility notIdentifiedDate] mergeReceiptID:0];
        
        [Receipt addObject:receipt];
        [receiptList addObject:receipt];
    }
    else
    {
        if(receipt.mergeReceiptID == -999)//case split bill
        {
            //separate order
            //split item one by one
            NSMutableArray *inDbOrderTakingList = _orderTakingList;
            NSMutableArray *inDbOrderNoteList = [OrderNote getOrderNoteListWithOrderTakingList:inDbOrderTakingList];
            NSMutableArray *inDbOrderKitchenList = [OrderKitchen getOrderKitchenListWithOrderTakingList:inDbOrderTakingList];
            NSMutableArray *splitOrderTakingList = [[NSMutableArray alloc]init];
            NSMutableArray *splitOrderNoteList = [[NSMutableArray alloc]init];
            NSMutableArray *splitOrderKitchenList = [[NSMutableArray alloc]init];
            for(OrderTaking *item in _orderTakingList)
            {
                for(int i=0; i<item.quantity; i++)
                {
                    OrderTaking *orderTaking = [item copy];
                    orderTaking.orderTakingID = [OrderTaking getNextID];
                    orderTaking.quantity = 1;
                    [OrderTaking addObject:orderTaking];
                    [splitOrderTakingList addObject:orderTaking];
                    
                    
                    
                    //create new orderNote
                    NSMutableArray *newOrderNoteList = [[NSMutableArray alloc]init];
                    NSMutableArray *orderNoteList = [OrderNote getOrderNoteListWithOrderTakingID:item.orderTakingID];
                    for(OrderNote *item in orderNoteList)
                    {
                        OrderNote *orderNote = [item copy];
                        orderNote.orderNoteID = [OrderNote getNextID];
                        orderNote.orderTakingID = orderTaking.orderTakingID;
                        [OrderNote addObject:orderNote];
                        [newOrderNoteList addObject:orderNote];
                    }
                    [splitOrderNoteList addObjectsFromArray:newOrderNoteList];
                    
                    
                    
                    
                    //create new orderKitchen
                    OrderKitchen *selectedOrderKitchen = [OrderKitchen getOrderKitchenWithOrderTakingID:item.orderTakingID];
                    OrderKitchen *orderKitchen = [selectedOrderKitchen copy];
                    orderKitchen.orderKitchenID = [OrderKitchen getNextID];
                    orderKitchen.orderTakingID = orderTaking.orderTakingID;
                    [OrderKitchen addObject:orderKitchen];
                    [splitOrderKitchenList addObject:orderKitchen];
                }
            }
            
            
            [OrderTaking removeList:inDbOrderTakingList];
            [OrderNote removeList:inDbOrderNoteList];
            [OrderKitchen removeList:inDbOrderKitchenList];
            
            
            _orderTakingList = splitOrderTakingList;
            orderNoteList = splitOrderNoteList;
            orderKitchenList = splitOrderKitchenList;
        }
    }
    

    
    NSMutableArray *status2OrderTakingList = [OrderTaking getOrderTakingListWithCustomerTableID:customerTable.customerTableID status:2];
    if(receipt && receipt.mergeReceiptID == -999 && [status2OrderTakingList count]==[_orderTakingList count])//split bill
    {
        [self.homeModel insertItems:dbOrderTakingOrderNoteOrderKitchenReceiptAndReceiptNo withData:@[_orderTakingList,orderNoteList,orderKitchenList,receiptList] actionScreen:@"insert orderTaking, orderNote, orderKitchen, receipt  in orderTaking screen"];
    }
    else
    {
        [self.homeModel insertItems:dbOrderTakingOrderNoteOrderKitchenReceipt withData:@[_orderTakingList,orderNoteList,orderKitchenList,receiptList] actionScreen:@"insert orderTaking, orderNote, orderKitchen, receipt in orderTaking screen"];
    }
    
    
    

    
    //tabletaking
    TableTaking *tableTaking = [TableTaking getTableTakingWithCustomerTableID:customerTable.customerTableID receiptID:0];
    if(tableTaking)
    {
        [self.homeModel insertItems:dbTableTakingInsertUpdate withData:tableTaking actionScreen:@"update if any or insert tableTaking in ordertaking screen"];
    }
    else
    {
        [self.homeModel deleteItems:dbTableTakingWithCustomerTable withData:customerTable actionScreen:@"delete tabletaking if any"];
    }
    
    
    
    
    
    //print kitchen bill
    _countPrint = 0;
    _countingPrint = 0;
    NSMutableDictionary *printDic = [[NSMutableDictionary alloc]init];
    _printBillWithPortName = [[NSMutableDictionary alloc]init];
    NSInteger printOrderKitchenByItem = [[Setting getSettingValueWithKeyName:@"printOrderKitchenByItem"] integerValue];
    {
        //split kitchen bill to various type printer
        
        //foodCheckList
        NSInteger printFoodCheckList = [[Setting getSettingValueWithKeyName:@"printFoodCheckList"] integerValue];
        NSInteger printerID = [[Setting getSettingValueWithKeyName:@"foodCheckList"] integerValue];
        if(printFoodCheckList && printerID)
        {
            NSMutableArray *printOrderKitchenList = [[NSMutableArray alloc]init];
            {
                if([orderKitchenList count]>0)
                {
                    [printOrderKitchenList addObject:orderKitchenList];
                }
            }
            if([printOrderKitchenList count]>0)
            {
                _countPrint = _countPrint+[printOrderKitchenList count];
                Printer *printer = [Printer getPrinter:printerID];
                [printDic setValue:printOrderKitchenList forKey:printer.portName];
            }
        }

    


        //printerKitchenMenuTypeID
        NSMutableArray *printerList = [Printer getPrinterList];
        for(int i=0; i<[printerList count]; i++)
        {
            Printer *printer = printerList[i];
            NSMutableArray *printOrderKitchenList = [[NSMutableArray alloc]init];
            NSString *printerKitchenMenuTypeID = printer.menuTypeIDListInText;
            NSArray* menuTypeIDList = [printerKitchenMenuTypeID componentsSeparatedByString: @","];
            for(NSString *item in menuTypeIDList)
            {
                NSMutableArray *orderKitchenMenuTypeIDList = [OrderKitchen getOrderKitchenListWithMenuTypeID:[item integerValue] orderKitchenList:orderKitchenList];
                
                if(printOrderKitchenByItem)
                {
                    for(OrderKitchen *orderKitchen in orderKitchenMenuTypeIDList)
                    {
                        OrderTaking *orderTaking = [OrderTaking getOrderTaking:orderKitchen.orderTakingID];
                        for(int i=0; i<orderTaking.quantity; i++)
                        {
                            NSMutableArray *orderKitchenList = [[NSMutableArray alloc]init];
                            [orderKitchenList addObject:orderKitchen];
                            [printOrderKitchenList addObject:orderKitchenList];
                        }
                    }
                }
                else
                {
                    [printOrderKitchenList addObject:orderKitchenMenuTypeIDList];
                }
            }
            if([printOrderKitchenList count]>0)
            {
                _countPrint = _countPrint+[printOrderKitchenList count];
                [printDic setValue:printOrderKitchenList forKey:printer.portName];
            }
        }
    
        
       
        
        
        //port with bill and order
        _arrOfHtmlContentList = [[NSMutableArray alloc]init];
        for(int i=0; i<_countPrint; i++)
        {
            UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 580,100)];
            webView.delegate = self;
            [self.view insertSubview:webView atIndex:0];
            [_webViewList addObject:webView];
        }
        int i=0;
        for(NSString *key in printDic)//printDic คือตัวเครื่องพิมพ์
        {
            NSMutableArray *printOrderKitchenList = [printDic objectForKey:key];
            for(NSMutableArray *orderKitchenMenuTypeIDList in printOrderKitchenList)
            {
                [_printBillWithPortName setValue:key forKey:[NSString stringWithFormat:@"%d",i]];
                if([key isEqualToString:@"foodCheckList"])//foodCheckList คือรวมทุกรายการในบิลเดียว หัวบิลแสดงคำว่าทั้งหมด, ถ้าไม่ใช่คือพิมพ์ 1 ที่ต่อ 1 บิล หัวบิลแสดงหมวดอาหารรายการนั้น
                {
                    [self printKitchenBill:orderKitchenMenuTypeIDList orderNo:i foodCheckList:YES];
                }
                else
                {
                    [self printKitchenBill:orderKitchenMenuTypeIDList orderNo:i foodCheckList:NO];
                }
                i++;
            }
        }        
    }
}

- (IBAction)rearrangeOrder:(id)sender
{
    
    [self reaarangeOrderWithUpdateOrderTakingListInDB:YES];
    [self reloadOrderTaking:YES];
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
        SubMenuType *subMenuType = [SubMenuType getSubMenuType:menu.subMenuTypeID];
        item.subMenuOrderNo = subMenuType.orderNo;
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_takeAway" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"_subMenuOrderNo" ascending:YES];
    NSSortDescriptor *sortDescriptor3 = [[NSSortDescriptor alloc] initWithKey:@"_menuOrderNo" ascending:YES];
    NSSortDescriptor *sortDescriptor4 = [[NSSortDescriptor alloc] initWithKey:@"_noteIDListInText" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor,sortDescriptor2,sortDescriptor3,sortDescriptor4,nil];
    NSArray *sortArray = [_orderTakingList sortedArrayUsingDescriptors:sortDescriptors];
    
    
    
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
                
                [reservedList removeAllObjects];
                j = 1;
            }
            else //ถ้าซ้ำกับตัวก่อนหน้า
            {
                j++;
            }
        }
        
        [reservedList addObject:item];
        previousTakeAway = item.takeAway;
        previousMenuOrderNo = item.menuOrderNo;
        previousNoteIDListInText = item.noteIDListInText;
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
    
    [reservedList removeAllObjects];
    
    

    //remove and update
    //remove ordertaking and also ordernote
    NSMutableArray *allOrderNoteList = [[NSMutableArray alloc]init];
    if([removeList count]>0)
    {
        for(OrderTaking *item in removeList)
        {
            NSMutableArray *orderNoteList = [OrderNote getOrderNoteListWithOrderTakingID:item.orderTakingID];
            [allOrderNoteList addObjectsFromArray:orderNoteList];
        }
    }
    [OrderNote removeList:allOrderNoteList];

    
    [OrderTaking removeList:removeList];

    
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

}

- (IBAction)rearrangeOrderTouchDown:(id)sender
{
    UIButton *button = sender;
    [button setImage:[UIImage imageNamed:@"shuffle light blue.png"] forState:UIControlStateNormal];
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [button setImage:[UIImage imageNamed:@"shuffle.png"] forState:UIControlStateNormal];
    });
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger numberOfSection = 1;
    if([collectionView isEqual:colVwMenuWithTakeAway])
    {
        numberOfSection = [_subMenuTypeList count];
    }
    
    return  numberOfSection;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if([collectionView isEqual:colVwOrderAdjust])
    {
        //load order มาโชว์
        return [_orderTakingList count];
    }
    else if([collectionView isEqual:colVwTabMenuType])
    {
        return [_menuTypeList count];
    }
    else if([collectionView isEqual:colVwMenuWithTakeAway])
    {
        //load menu มาโชว์
        NSMutableArray *menuList = _arrOfmenuList[section];
        return [menuList count];
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger item = indexPath.item;
    NSInteger section = indexPath.section;
    if([collectionView isEqual:colVwOrderAdjust])
    {
        CustomCollectionViewCellOrderAdjust *cell = (CustomCollectionViewCellOrderAdjust*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierOrderAdjust forIndexPath:indexPath];
        
        
        cell.contentView.userInteractionEnabled = NO;
        if(item == _selectedOrderAdjustItem)
        {
            cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        }
        else
        {
            cell.backgroundColor = [UIColor clearColor];
        }
        
        
        
        //menu name
        OrderTaking *orderTaking = _orderTakingList[item];
        Menu *menu = [Menu getMenu:orderTaking.menuID];
        if(orderTaking.specialPrice == orderTaking.price)
        {
            cell.lblTotalPrice.textColor = [UIColor blackColor];
        }
        else
        {
            cell.lblTotalPrice.textColor = mRed;
        }
        
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
        
        
        CGSize menuNameLabelSize = [self suggestedSizeWithFont:cell.lblMenuName.font size:CGSizeMake(colVwOrderAdjust.frame.size.width - 50-16-16-8, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:cell.lblMenuName.text];//153 from storyboard
        CGRect frame = cell.lblMenuName.frame;
        frame.size.width = menuNameLabelSize.width;
        frame.size.height = menuNameLabelSize.height;
        cell.lblMenuName.frame = frame;
        
        
        
        //note
        NSMutableAttributedString *strAllNote;
        NSMutableAttributedString *attrStringRemove;
        NSMutableAttributedString *attrStringAdd;
        NSString *strRemoveTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:-1];
        NSString *strAddTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:1];
        if(![Utility isStringEmpty:strRemoveTypeNote])
        {
            UIFont *font = [UIFont systemFontOfSize:11];
            NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
            attrStringRemove = [[NSMutableAttributedString alloc] initWithString:@"ไม่ใส่" attributes:attribute];
            
            
            UIFont *font2 = [UIFont systemFontOfSize:11];
            NSDictionary *attribute2 = @{NSFontAttributeName: font2};
            NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strRemoveTypeNote] attributes:attribute2];
            
            
            [attrStringRemove appendAttributedString:attrString2];
        }
        if(![Utility isStringEmpty:strAddTypeNote])
        {
            UIFont *font = [UIFont systemFontOfSize:11];
            NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
            attrStringAdd = [[NSMutableAttributedString alloc] initWithString:@"เพิ่ม" attributes:attribute];
            
            
            UIFont *font2 = [UIFont systemFontOfSize:11];
            NSDictionary *attribute2 = @{NSFontAttributeName: font2};
            NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strAddTypeNote] attributes:attribute2];
            
            
            [attrStringAdd appendAttributedString:attrString2];
        }
        if(![Utility isStringEmpty:strRemoveTypeNote])
        {
            strAllNote = attrStringRemove;
            if(![Utility isStringEmpty:strAddTypeNote])
            {
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"\n" attributes:nil];
                [strAllNote appendAttributedString:attrString];
                [strAllNote appendAttributedString:attrStringAdd];
            }
        }
        else
        {
            if(![Utility isStringEmpty:strAddTypeNote])
            {
                strAllNote = attrStringAdd;
            }
            else
            {
                strAllNote = [[NSMutableAttributedString alloc]init];
            }
        }
        cell.lblNote.attributedText = strAllNote;
        
        
        
        CGSize noteLabelSize = [self suggestedSizeWithFont:cell.lblNote.font size:CGSizeMake(colVwOrderAdjust.frame.size.width - 50-16-16-8, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:[strAllNote string]];
        CGRect frame2 = cell.lblNote.frame;
        frame2.size.width = noteLabelSize.width;
        frame2.size.height = noteLabelSize.height;
        cell.lblNote.frame = frame2;
    
        
        
        //total price
        NSString *strTotalPrice = [Utility formatDecimal:orderTaking.quantity*orderTaking.specialPrice withMinFraction:0 andMaxFraction:0];
        cell.lblTotalPrice.text = [NSString stringWithFormat:@"฿%@",strTotalPrice];
        
        
        //quantity
        NSString *strQuantity = [Utility formatDecimal:orderTaking.quantity withMinFraction:0 andMaxFraction:0];
        cell.lblQuantity.text = strQuantity;
        
        
        //add note
        cell.btnAddNote.tag = item;
        [cell.btnAddNote addTarget:self action:@selector(addNoteTouchDown:) forControlEvents:UIControlEventTouchDown];
        [cell.btnAddNote addTarget:self action:@selector(addNote:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //move to trash
        cell.btnMoveToTrash.tag = item;
        [cell.btnMoveToTrash addTarget:self action:@selector(moveToTrashTouchDown:) forControlEvents:UIControlEventTouchDown];
        [cell.btnMoveToTrash addTarget:self action:@selector(moveToTrash:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //increment
        cell.btnIncrement.tag = item;
        [cell.btnIncrement addTarget:self action:@selector(incrementTouchDown:) forControlEvents:UIControlEventTouchDown];
        [cell.btnIncrement addTarget:self action:@selector(increment:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //decrement
        cell.btnDecrement.tag = item;
        [cell.btnDecrement addTarget:self action:@selector(decrementTouchDown:) forControlEvents:UIControlEventTouchDown];
        [cell.btnDecrement addTarget:self action:@selector(decrement:) forControlEvents:UIControlEventTouchUpInside];
        
        
        return cell;
    }
    else if([collectionView isEqual:colVwTabMenuType])
    {
        CustomCollectionViewCellTabMenuType *cell = (CustomCollectionViewCellTabMenuType*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierOrderTabMenuType forIndexPath:indexPath];
        
        MenuType *menuType = _menuTypeList[item];
        cell.lblMenuType.text = menuType.name;
        if(item == _selectedIndexMenuType)
        {
            cell.vwBottomBorder.hidden = YES;
            cell.lblMenuType.font = [UIFont boldSystemFontOfSize:15.0f];
            cell.backgroundColor = mLightBlueColor;
            cell.lblMenuType.textColor = mBlueColor;
        }
        else
        {
            cell.vwBottomBorder.hidden = YES;
            cell.lblMenuType.font = [UIFont systemFontOfSize:15.0f];
            cell.backgroundColor = [UIColor clearColor];
            cell.lblMenuType.textColor = mGrayColor;
        }
        
        
        cell.layer.cornerRadius = 4;
        
        
        return cell;
    }
    else if([collectionView isEqual:colVwMenuWithTakeAway])
    {
        CustomCollectionViewCellMenuWithTakeAway *cell = (CustomCollectionViewCellMenuWithTakeAway*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierMenuWithTakeAway forIndexPath:indexPath];
        
        
        
        cell.contentView.userInteractionEnabled = NO;
        NSMutableArray *menuList = _arrOfmenuList[section];
        Menu *menu = menuList[item];
        
        
        //tap menu
        NSString *strDisplayMenu = [NSString stringWithFormat:@"%@: %@",menu.menuCode,menu.titleThai];
        cell.btnMenuName.tag = item;
        [cell.btnMenuName setTitle:strDisplayMenu forState:UIControlStateNormal];
        [cell.btnMenuName addTarget:self action:@selector(addOrderTouchDown:) forControlEvents:UIControlEventTouchDown];
        [cell.btnMenuName addTarget:self action:@selector(addOrder:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //take away
        cell.btnTakeAway.tag = menu.menuID;
        [cell.btnTakeAway addTarget:self action:@selector(takeAwayTouchDown:) forControlEvents:UIControlEventTouchDown];
        [cell.btnTakeAway addTarget:self action:@selector(takeAway:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        UIColor *color = UIColorFromRGB([Utility hexStringToInt:menu.color]);
        cell.backgroundColor = color;
        [self makeBottomRightRoundedCorner:cell.vwRoundedCorner];
        
        
        return cell;
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([collectionView isEqual:colVwTabMenuType])
    {
       _selectedIndexMenuType = indexPath.item;
        
        
        
        CustomCollectionViewCellTabMenuType * cell = (CustomCollectionViewCellTabMenuType *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.vwBottomBorder.hidden = YES;
        cell.lblMenuType.font = [UIFont boldSystemFontOfSize:15.0f];
        cell.lblMenuType.textColor = mBlueColor;
        cell.backgroundColor = mLightBlueColor;
        
        
        
        
        [_arrOfmenuList removeAllObjects];
        MenuType *menuType = _menuTypeList[_selectedIndexMenuType];
        _subMenuTypeList = [SubMenuType getSubMenuTypeListWithMenuTypeID:menuType.menuTypeID status:1];
        if([_subMenuTypeList count] == 0)
        {
            NSMutableArray *menuList = [Menu getMenuListWithMenuTypeID:menuType.menuTypeID status:1];
            menuList = [Utility sortDataByColumn:menuList numOfColumn:2];
            if([menuList count] == 0)
            {
                [_arrOfmenuList addObject:_emptyMenuList];
            }
            else
            {
                [_arrOfmenuList addObject:menuList];
            }
        }
        else
        {
            for(SubMenuType *item in _subMenuTypeList)
            {
                NSMutableArray *menuList = [Menu getMenuListWithMenuTypeID:menuType.menuTypeID subMenuTypeID:item.subMenuTypeID status:1];
                menuList = [Utility sortDataByColumn:menuList numOfColumn:2];
                [_arrOfmenuList addObject:menuList];
            }
        }
        
        
        [colVwMenuWithTakeAway reloadData];
    }
    else if([collectionView isEqual:colVwOrderAdjust])
    {
        //programmatically select
        CustomCollectionViewCellOrderAdjust * cell = (CustomCollectionViewCellOrderAdjust *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.backgroundColor = _blinkColor;
        _blinkColor = [UIColor clearColor];
        
        
        double delayInSeconds = 0.3;
        dispatch_time_t popTime2 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime2, dispatch_get_main_queue(), ^(void){
            [self collectionView:colVwOrderAdjust didDeselectItemAtIndexPath:indexPath];
        });
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([collectionView isEqual:colVwTabMenuType])
    {
        CustomCollectionViewCellTabMenuType* cell = (CustomCollectionViewCellTabMenuType *)[collectionView cellForItemAtIndexPath:indexPath];
        
        cell.vwBottomBorder.hidden = YES;
        cell.lblMenuType.font = [UIFont systemFontOfSize:15.0f];
        cell.backgroundColor = [UIColor clearColor];
        cell.lblMenuType.textColor = mGrayColor;
    }
    else if([collectionView isEqual:colVwOrderAdjust])
    {
        //programmatically deselect
        CustomCollectionViewCellOrderAdjust * cell = (CustomCollectionViewCellOrderAdjust *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
    }
}

#pragma mark <UICollectionViewDelegate>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(0, 0);
    if([collectionView isEqual:colVwOrderAdjust])
    {
        //load order มาโชว์
        OrderTaking *orderTaking = _orderTakingList[indexPath.item];
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
        
        
        //note
        NSMutableAttributedString *strAllNote;
        NSMutableAttributedString *attrStringRemove;
        NSMutableAttributedString *attrStringAdd;
        NSString *strRemoveTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:-1];
        NSString *strAddTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:1];
        if(![Utility isStringEmpty:strRemoveTypeNote])
        {
            UIFont *font = [UIFont systemFontOfSize:11];
            NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
            attrStringRemove = [[NSMutableAttributedString alloc] initWithString:@"ไม่ใส่" attributes:attribute];
            
            
            UIFont *font2 = [UIFont systemFontOfSize:11];
            NSDictionary *attribute2 = @{NSFontAttributeName: font2};
            NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strRemoveTypeNote] attributes:attribute2];
            
            
            [attrStringRemove appendAttributedString:attrString2];
        }
        if(![Utility isStringEmpty:strAddTypeNote])
        {
            UIFont *font = [UIFont systemFontOfSize:11];
            NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
            attrStringAdd = [[NSMutableAttributedString alloc] initWithString:@"เพิ่ม" attributes:attribute];
            
            
            UIFont *font2 = [UIFont systemFontOfSize:11];
            NSDictionary *attribute2 = @{NSFontAttributeName: font2};
            NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strAddTypeNote] attributes:attribute2];
            
            
            [attrStringAdd appendAttributedString:attrString2];
        }
        if(![Utility isStringEmpty:strRemoveTypeNote])
        {
            strAllNote = attrStringRemove;
            if(![Utility isStringEmpty:strAddTypeNote])
            {
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"\n" attributes:nil];
                [strAllNote appendAttributedString:attrString];
                [strAllNote appendAttributedString:attrStringAdd];
            }
        }
        else
        {
            if(![Utility isStringEmpty:strAddTypeNote])
            {
                strAllNote = attrStringAdd;
            }
            else
            {
                strAllNote = [[NSMutableAttributedString alloc]init];
            }
        }
        
        
        
        UIFont *fontMenuName = [UIFont systemFontOfSize:14.0];
        UIFont *fontNote = [UIFont systemFontOfSize:11.0];
        
        
        CGSize menuNameLabelSize = [self suggestedSizeWithFont:fontMenuName size:CGSizeMake(colVwOrderAdjust.frame.size.width - 50-16-16-8, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:strMenuName];//153 from storyboard
        CGSize noteLabelSize = [self suggestedSizeWithFont:fontNote size:CGSizeMake(colVwOrderAdjust.frame.size.width - 50-16-16-8, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:[strAllNote string]];
        
        
        float height = menuNameLabelSize.height+noteLabelSize.height+30+8+15+8;
        size = CGSizeMake(colVwOrderAdjust.frame.size.width,height);
    }
    else if([collectionView isEqual:colVwTabMenuType])
    {
        float row = 2;
        NSInteger column = ceil([_menuTypeList count]/row);
        size = CGSizeMake(colVwTabMenuType.frame.size.width/column,colVwTabMenuType.frame.size.height/row);
    }
    else if([collectionView isEqual:colVwMenuWithTakeAway])
    {
        //load menu มาโชว์
        size = CGSizeMake(colVwMenuWithTakeAway.frame.size.width/2,44);
    }
    
    
    return size;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)colVwOrderAdjust.collectionViewLayout;
        
        [layout invalidateLayout];
        [colVwOrderAdjust reloadData];
    }
    {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)colVwTabMenuType.collectionViewLayout;
        
        [layout invalidateLayout];
        [colVwTabMenuType reloadData];
    }
    {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)colVwMenuWithTakeAway.collectionViewLayout;
        
        [layout invalidateLayout];
        [colVwMenuWithTakeAway reloadData];
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
    NSInteger section = indexPath.section;
    UICollectionReusableView *reusableview = nil;
    
    
    if([collectionView isEqual:colVwMenuWithTakeAway])
    {
        if (kind == UICollectionElementKindSectionHeader)
        {
            CustomCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderViewIdentifier forIndexPath:indexPath];
            
            [self setShadow:headerView];
            if(section == 0)
            {
                if([_arrOfmenuList count] > 1)
                {
                    SubMenuType *subMenuType = _subMenuTypeList[section];
                    headerView.lblHeaderName.text = subMenuType.name;
                }
            }
            else
            {
                SubMenuType *subMenuType = _subMenuTypeList[section];
                headerView.lblHeaderName.text = subMenuType.name;
            }
            
            reusableview = headerView;
        }
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
    if([collectionView isEqual:colVwMenuWithTakeAway])
    {
        if(section == 0)
        {
            if([_arrOfmenuList count] > 1)
            {
                //show header
                headerSize = CGSizeMake(collectionView.bounds.size.width, 25);
            }
        }
        else
        {
            headerSize = CGSizeMake(collectionView.bounds.size.width, 25);
        }
    }
    return headerSize;
}

#pragma mark - LXReorderableCollectionViewDataSource methods

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath {
    
    
    NSLog(@"will move to index path");
    NSMutableArray *menuList = _arrOfmenuList[fromIndexPath.section];
    Menu *menu = menuList[fromIndexPath.item];
    [menuList removeObjectAtIndex:fromIndexPath.item];
    
    NSMutableArray *menuList2 = _arrOfmenuList[toIndexPath.section];
    [menuList2 insertObject:menu atIndex:toIndexPath.item];
    
}

- (void)addOrderTouchDown:(id)sender
{
    UIButton *button = sender;
    [button setTitleColor:mBlueColor forState:UIControlStateNormal];
    double delayInSeconds = 0.3;//delay 1.3 เพราะไม่อยากให้กดเบิ้ล(กด insert และ update ด้วยปุ่มเดิม) หน่วงเพื่อหลอกตา แต่ว่ามีเช็ค idinserted เผื่อไว้อยู่แล้ว จะใช้ 0.3 กรณีที่ไม่ได้ต้องกดต่อเนื่อง คือ insert แล้ว update หรือ delete โดยใช้ปุ่มเดิม
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    });
}

- (void)addOrder:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:colVwMenuWithTakeAway];
    NSIndexPath *tappedIP = [colVwMenuWithTakeAway indexPathForItemAtPoint:buttonPosition];
    NSMutableArray *menuList = _arrOfmenuList[tappedIP.section];
    Menu *menu = menuList[tappedIP.item];
    
    
    OrderTaking *orderTakingExist = [OrderTaking getOrderTakingWithCustomerTableID:customerTable.customerTableID menuID:menu.menuID takeAway:0 noteIDListInText:@"" status:1];
    
    //update
    if(orderTakingExist)
    {
        orderTakingExist.quantity += 1;
        orderTakingExist.modifiedUser = [Utility modifiedUser];
        orderTakingExist.modifiedDate = [Utility currentDateTime];
        
        
        [self reloadOrderTaking:NO];
        
        
        //scroll to affected cell and blink
        //get indexPath
        int i=0;
        for(OrderTaking *item in _orderTakingList)
        {
            if(item.orderTakingID == orderTakingExist.orderTakingID)
            {
                break;
            }
            i++;
        }
        
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [colVwOrderAdjust scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        
        double delayInSeconds = 0.3;
        dispatch_time_t popTime2 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime2, dispatch_get_main_queue(), ^(void){
            _blinkColor = [UIColor groupTableViewBackgroundColor];;
            [self collectionView:colVwOrderAdjust didSelectItemAtIndexPath:indexPath];
        });
    }
    else
    {
        SpecialPriceProgram *specialPriceProgram = [SpecialPriceProgram getSpecialPriceProgramTodayWithMenuID:menu.menuID];
        float specialPrice = specialPriceProgram?specialPriceProgram.specialPrice:menu.price;
        OrderTaking *orderTaking = [[OrderTaking alloc]initWithCustomerTableID:customerTable.customerTableID menuID:menu.menuID quantity:1 specialPrice:specialPrice price:menu.price takeAway:0 noteIDListInText:@"" orderNo:0 status:1 receiptID:0];
        [OrderTaking addObject:orderTaking];


        [self reloadOrderTaking:NO];
        
        
        //scroll to affected cell
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[_orderTakingList count]-1 inSection:0];
        [colVwOrderAdjust scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
}

- (void)takeAwayTouchDown:(id)sender
{
    UIButton *button = sender;
    [button setImage:[UIImage imageNamed:@"Take away light blue.png"] forState:UIControlStateNormal];
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [button setImage:[UIImage imageNamed:@"take away2.png"] forState:UIControlStateNormal];
    });
}

- (void)takeAway:(id)sender
{
    UIButton *button = sender;
    NSInteger menuID = button.tag;
    Menu *menu = [Menu getMenu:menuID];
    
    OrderTaking *orderTakingExist = [OrderTaking getOrderTakingWithCustomerTableID:customerTable.customerTableID menuID:menuID takeAway:1 noteIDListInText:@"" status:1];
    if(orderTakingExist)
    {
        orderTakingExist.quantity += 1;
        orderTakingExist.modifiedUser = [Utility modifiedUser];
        orderTakingExist.modifiedDate = [Utility currentDateTime];
        
        
        
        [self reloadOrderTaking:NO];
        
        
        //scroll to affected cell and blink
        //get indexPath
        int i=0;
        for(OrderTaking *item in _orderTakingList)
        {
            if(item.orderTakingID == orderTakingExist.orderTakingID)
            {
                break;
            }
            i++;
        }
        
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [colVwOrderAdjust scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        
        double delayInSeconds = 0.3;
        dispatch_time_t popTime2 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime2, dispatch_get_main_queue(), ^(void){
            _blinkColor = [UIColor groupTableViewBackgroundColor];;
            [self collectionView:colVwOrderAdjust didSelectItemAtIndexPath:indexPath];
        });
        
    }
    else
    {
        float takeAwayFee = [[Setting getSettingValueWithKeyName:@"takeAwayFee"] floatValue];
        SpecialPriceProgram *specialPriceProgram = [SpecialPriceProgram getSpecialPriceProgramTodayWithMenuID:menuID];
        float menuPrice = menu.price + takeAwayFee;
        float specialPrice = specialPriceProgram?specialPriceProgram.specialPrice:menu.price;
        specialPrice += takeAwayFee;
        OrderTaking *orderTaking = [[OrderTaking alloc]initWithCustomerTableID:customerTable.customerTableID menuID:menuID quantity:1 specialPrice:specialPrice price:menuPrice takeAway:1 noteIDListInText:@"" orderNo:0 status:1 receiptID:0];
        [OrderTaking addObject:orderTaking];

        
        [self reloadOrderTaking:NO];
        
        
        //scroll to affected cell
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[_orderTakingList count]-1 inSection:0];
        [colVwOrderAdjust scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
}

- (void)addNoteTouchDown:(id)sender
{
    UIButton *button = sender;
    [button setImage:[UIImage imageNamed:@"Add note light blue.png"] forState:UIControlStateNormal];
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [button setImage:[UIImage imageNamed:@"Add note.png"] forState:UIControlStateNormal];
    });
}

- (void)addNote:(id)sender
{
    UIButton *button = sender;
    NSInteger item = button.tag;
    _selectedOrderAdjustItem = item;
    
    
    OrderTaking *orderTaking = _orderTakingList[item];
    Menu *menu = [Menu getMenu:orderTaking.menuID];
    _noteList = [MenuTypeNote getNoteListWithMenuTypeID:menu.menuTypeID];
    
    
    
    
    // grab the view controller we want to show
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NoteViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"NoteViewController"];
    controller.preferredContentSize = CGSizeMake(728, 728);
    controller.noteList = _noteList;
    controller.orderTaking = orderTaking;
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
    _notePopController = popController;
    
    
    
    // in case we don't have a bar button as reference
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        CustomCollectionViewCellOrderAdjust *cell = (CustomCollectionViewCellOrderAdjust *)[colVwOrderAdjust cellForItemAtIndexPath:indexPath];
    popController.sourceView = cell;
    popController.sourceRect = cell.bounds;

}

- (void)moveToTrashTouchDown:(id)sender
{
    UIButton *button = sender;
    [button setImage:[UIImage imageNamed:@"Trash light blue.png"] forState:UIControlStateNormal];
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [button setImage:[UIImage imageNamed:@"Trash color.png"] forState:UIControlStateNormal];
    });
}

- (void)moveToTrash:(id)sender
{
    UIButton *button = sender;
    NSInteger item = button.tag;
    OrderTaking *orderTaking = _orderTakingList[item];
    
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:
     [UIAlertAction actionWithTitle:@"ลบรายการ"
                              style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
      {
          NSMutableArray *orderNoteList = [OrderNote getOrderNoteListWithOrderTakingID:orderTaking.orderTakingID];
          [OrderTaking removeObject:orderTaking];
          [OrderNote removeList:orderNoteList];
          
          
          [self reloadOrderTaking:YES];
      }]];
    
    [alert addAction:
     [UIAlertAction actionWithTitle:@"ยกเลิก"
                              style:UIAlertActionStyleCancel
                            handler:^(UIAlertAction *action) {}]];
    
    
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        CustomCollectionViewCellOrderAdjust *cell = (CustomCollectionViewCellOrderAdjust *)[colVwOrderAdjust cellForItemAtIndexPath:indexPath];
        
        
        [alert setModalPresentationStyle:UIModalPresentationPopover];
        
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        CGRect frame = cell.btnMoveToTrash.bounds;
        frame.origin.y = frame.origin.y-15;
        popPresenter.sourceView = cell.btnMoveToTrash;
        popPresenter.sourceRect = frame;
    }
    
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)incrementTouchDown:(id)sender
{
    UIButton *button = sender;
    [button setImage:[UIImage imageNamed:@"increment light blue.png"] forState:UIControlStateNormal];
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [button setImage:[UIImage imageNamed:@"increment.png"] forState:UIControlStateNormal];
    });
}

- (void)increment:(id)sender
{
    UIButton *button = sender;
    NSInteger item = button.tag;
    OrderTaking *orderTaking = _orderTakingList[item];
    
    
    orderTaking.quantity += 1;
    orderTaking.modifiedUser = [Utility modifiedUser];
    orderTaking.modifiedDate = [Utility currentDateTime];
    
    
    
    
    //update display quantity and total price
    CustomCollectionViewCellOrderAdjust *cell = (CustomCollectionViewCellOrderAdjust *)[colVwOrderAdjust cellForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0]];
    cell.lblQuantity.text = [Utility formatDecimal:orderTaking.quantity withMinFraction:0 andMaxFraction:0];
    cell.lblTotalPrice.text = [Utility formatDecimal:orderTaking.quantity*orderTaking.specialPrice withMinFraction:0 andMaxFraction:0];
    
    
    //update total order and total amount
    [self updateTotalOrderAndAmount];
}

- (void)decrementTouchDown:(id)sender
{
    UIButton *button = sender;
    [button setImage:[UIImage imageNamed:@"decrement light blue.png"] forState:UIControlStateNormal];
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [button setImage:[UIImage imageNamed:@"decrement.png"] forState:UIControlStateNormal];
    });
}

- (void)decrement:(id)sender
{
    UIButton *button = sender;
    NSInteger item = button.tag;
    OrderTaking *orderTaking = _orderTakingList[item];
    
    

    
    if(orderTaking.quantity == 1)
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:
         [UIAlertAction actionWithTitle:@"ลบรายการ"
                                  style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
          {
              NSMutableArray *orderNoteList = [OrderNote getOrderNoteListWithOrderTakingID:orderTaking.orderTakingID];
              [OrderTaking removeObject:orderTaking];
              [OrderNote removeList:orderNoteList];

              
              
              [self reloadOrderTaking:NO];//update เฉพาะ cell ลำบาก เนืองจากเป็นการ remove cell เลยเรียก colvw reload ไปเลย
              
          }]];
        [alert addAction:
         [UIAlertAction actionWithTitle:@"ยกเลิก"
                                  style:UIAlertActionStyleCancel
                                handler:^(UIAlertAction *action) {}]];
        
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
            CustomCollectionViewCellOrderAdjust *cell = (CustomCollectionViewCellOrderAdjust *)[colVwOrderAdjust cellForItemAtIndexPath:indexPath];
            
            
            [alert setModalPresentationStyle:UIModalPresentationPopover];
            
            UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
            CGRect frame = cell.btnDecrement.bounds;
            frame.origin.y = frame.origin.y-15;
            popPresenter.sourceView = cell.btnDecrement;
            popPresenter.sourceRect = frame;
        }
        
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if(orderTaking.quantity >=2)
    {
        orderTaking.quantity -= 1;
        orderTaking.modifiedUser = [Utility modifiedUser];
        orderTaking.modifiedDate = [Utility currentDateTime];

        
        
        //ไม่เรียก colvw reload เพราะมันจะ decrement touch down ผิด cell เลย update เฉพาะ cell ที่แก้ไขไป
        //update display quantity and total price
        CustomCollectionViewCellOrderAdjust *cell = (CustomCollectionViewCellOrderAdjust *)[colVwOrderAdjust cellForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0]];
        cell.lblQuantity.text = [Utility formatDecimal:orderTaking.quantity withMinFraction:0 andMaxFraction:0];
        cell.lblTotalPrice.text = [Utility formatDecimal:orderTaking.quantity*orderTaking.specialPrice withMinFraction:0 andMaxFraction:0];
        
        
        //update total order and total amount
        [self updateTotalOrderAndAmount];
    }
    

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([textField isEqual:txtServingPerson])
    
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

-(void)printKitchenBill:(NSMutableArray *)orderKitchenList orderNo:(NSInteger)orderNo foodCheckList:(BOOL)foodCheckList
{
    //prepare data to print
    NSInteger printOrderKitchenByItem = [[Setting getSettingValueWithKeyName:@"printOrderKitchenByItem"] integerValue];
    OrderKitchen *orderKitchen = orderKitchenList[0];
    OrderTaking *orderTaking = [OrderTaking getOrderTaking:orderKitchen.orderTakingID];
    Menu *menu = [Menu getMenu:orderTaking.menuID];
    MenuType *menuType = [MenuType getMenuType:menu.menuTypeID];
    NSString *restaurantName = [Setting getSettingValueWithKeyName:@"restaurantName"];
    NSString *customerType = customerTable.tableName;
    NSString *waiterName = [UserAccount getFirstNameWithFullName:[UserAccount getCurrentUserAccount].fullName];
    NSString *strMenuType = foodCheckList?@"ทั้งหมด":menuType.name;
    NSString *sequenceNo = [NSString stringWithFormat:@"%ld",orderKitchen.sequenceNo];
    NSString *sendToKitchenTime = [Utility dateToString:orderKitchen.modifiedDate toFormat:@"yyyy-MM-dd HH:mm"];
    
    
    
    
    //items
    float sumQuantity = 0;
    NSMutableArray *items = [[NSMutableArray alloc]init];
    for(OrderKitchen *item in orderKitchenList)
    {
        NSMutableDictionary *dicItem = [[NSMutableDictionary alloc]init];
        
        OrderTaking *orderTaking = [OrderTaking getOrderTaking:item.orderTakingID];
        NSString *strQuantity = [Utility formatDecimal:orderTaking.quantity withMinFraction:0 andMaxFraction:0];
        Menu *menu = [Menu getMenu:orderTaking.menuID];
        NSString *removeTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:item.orderTakingID noteType:-1];
        NSString *addTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:item.orderTakingID noteType:1];
        
        if(printOrderKitchenByItem)
        {
            strQuantity = @"1";
        }
        //take away
        NSString *strTakeAway = @"";
        if(orderTaking.takeAway)
        {
            strTakeAway = @"ใส่ห่อ";
        }
        
        [dicItem setValue:strQuantity forKey:@"quantity"];
        [dicItem setValue:strTakeAway forKey:@"takeAway"];
        [dicItem setValue:menu.titleThai forKey:@"menu"];
        [dicItem setValue:removeTypeNote forKey:@"removeTypeNote"];
        [dicItem setValue:addTypeNote forKey:@"addTypeNote"];
        [dicItem setValue:@"" forKey:@"pro"];
        [dicItem setValue:@"" forKey:@"totalPricePerItem"];
        [items addObject:dicItem];
        
        sumQuantity += orderTaking.quantity;
    }
    if(printOrderKitchenByItem)
    {
        sumQuantity = 1;
    }
    NSString *strTotalQuantity = [Utility formatDecimal:sumQuantity withMinFraction:0 andMaxFraction:0];
    
    
    
    //create html invoice
    InvoiceComposer *invoiceComposer = [[InvoiceComposer alloc]init];
    NSString *invoiceHtml = [invoiceComposer renderKitchenBillWithRestaurantName:restaurantName customerType:customerType waiterName:waiterName menuType:strMenuType sequenceNo:sequenceNo sendToKitchenTime:sendToKitchenTime totalQuantity:strTotalQuantity items:items];
    
    
    
    
    UIWebView *webView = _webViewList[orderNo];
    webView.tag = orderNo;
    [webView loadHTMLString:invoiceHtml baseURL:NULL];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    [super webViewDidFinishLoad:aWebView];
    if(self.receiptKitchenBill)
    {
        self.receiptKitchenBill = 0;
        return;
    }
    
    
    
    _countingPrint++;
    NSString *strFileName = [NSString stringWithFormat:@"kitchenBill%ld.pdf",aWebView.tag];
    NSString *pdfFileName = [self createPDFfromUIView:aWebView saveToDocumentsWithFileName:strFileName];
    
    


    //convert pdf to uiimage
    NSURL *pdfUrl = [NSURL fileURLWithPath:pdfFileName];
    UIImage *pdfImagePrint = [self pdfToImage:pdfUrl];
    UIImageWriteToSavedPhotosAlbum(pdfImagePrint, nil, nil, nil);
    
    
    NSLog(@"path: %@",pdfFileName);
//    //TEST
//    [self removeOverlayViews];
//    return;
    
    
    NSString *printBill = [Setting getSettingValueWithKeyName:@"printBill"];
    if(![printBill integerValue])
    {
        if(_countingPrint == _countPrint)
        {
            [self hideStatus];
            [self removeOverlayViews];
            [self performSegueWithIdentifier:@"segUnwindToCustomerTable" sender:self];
        }
    }
    else
    {
        //print process
        NSString *portName = [_printBillWithPortName valueForKey:[NSString stringWithFormat:@"%ld",(long)aWebView.tag]];        
        [self doPrintProcess:pdfImagePrint portName:portName];
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
                                                 if(_countingPrint == _countPrint)
                                                 {
                                                     [self hideStatus];
                                                     [self removeOverlayViews];
                                                     [self performSegueWithIdentifier:@"segUnwindToCustomerTable" sender:self];
                                                 }
//                                                 [self hideStatus];
//                                                 [self removeOverlayViews];
//                                                 [self performSegueWithIdentifier:@"segUnwindToCustomerTable" sender:self];
                                             }];
             
             [alert addAction:defaultAction];
             [self presentViewController:alert animated:YES completion:nil];
         }
         else
         {
             if(_countingPrint == _countPrint)
             {
                 [self hideStatus];
                 [self removeOverlayViews];
                 [self performSegueWithIdentifier:@"segUnwindToCustomerTable" sender:self];
             }
         }
     }];
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController;
{
    if([popoverPresentationController isEqual:_notePopController])
    {
        return NO;
    }
    return YES;
}


@end
