//
//  OrderTakingViewController.m
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/6/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "OrderTakingViewController.h"
#import "CustomCollectionViewCellOrderAdjustHeader.h"
#import "CustomCollectionViewCellOrderAdjust.h"
#import "CustomCollectionViewCellTabMenuType.h"
#import "CustomCollectionViewCellMenuWithTakeAway.h"
#import "MenuType.h"
#import "Menu.h"
#import "TableTaking.h"
#import "OrderTaking.h"
#import "MenuTypeNote.h"
#import "Note.h"
#import "OrderNote.h"
#import "OrderKitchen.h"
#import "Utility.h"


@interface OrderTakingViewController ()
{
    NSMutableArray *_menuTypeList;
    NSMutableArray *_menuList;
    NSMutableArray *_orderTakingList;
    NSInteger _selectedIndexMenuType;
    NSMutableArray *_noteList;
    NSInteger _selectedOrderAdjustItem;
    UIColor *_blinkColor;
//    UITapGestureRecognizer *_tapPopUpRecognizer;
}
@end

@implementation OrderTakingViewController
static NSString * const reuseIdentifierOrderAdjustHeader = @"CustomCollectionViewCellOrderAdjustHeader";
static NSString * const reuseHeaderViewIdentifier = @"HeaderView";
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
@synthesize tbvNote;
@synthesize btnRearrange;
@synthesize vwBottomLabelAndButton;
@synthesize vwTableNameAndServingPerson;
@synthesize vwConfirmAndCancel;


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self closeNote:nil];
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
            //delete
            TableTaking *tableTakingExist = [TableTaking getTableTakingWithCustomerTableID:customerTable.customerTableID status:1];
            if(tableTakingExist)
            {
                //delete
                if(tableTakingExist.idInserted)
                {
                    [TableTaking removeObject:tableTakingExist];
                    [self.homeModel deleteItems:dbTableTaking withData:tableTakingExist actionScreen:@"delete serving person in order taking screen"];
                }
                else
                {
                    [self showAlertAndCallPushSync:@"" message:@"แก้ไขไม่ได้ กรุณาลองใหม่อีกครั้ง"];
                    NSString *strServingPerson = [Utility formatDecimal:tableTakingExist.servingPerson withMinFraction:0 andMaxFraction:0];
                    textField.text = strServingPerson;
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
            TableTaking *tableTakingExist = [TableTaking getTableTakingWithCustomerTableID:customerTable.customerTableID status:1];
            if(tableTakingExist)
            {
                //update
                if(tableTakingExist.idInserted)
                {
                    tableTakingExist.servingPerson = [txtServingPerson.text integerValue];
                    tableTakingExist.modifiedUser = [Utility modifiedUser];
                    tableTakingExist.modifiedDate = [Utility currentDateTime];
                    [self.homeModel updateItems:dbTableTaking withData:tableTakingExist actionScreen:@"update serving person in order taking screen"];
                }
                else
                {
                    [self showAlertAndCallPushSync:@"" message:@"แก้ไขไม่ได้ กรุณาลองใหม่อีกครั้ง"];
                    NSString *strServingPerson = [Utility formatDecimal:tableTakingExist.servingPerson withMinFraction:0 andMaxFraction:0];
                    textField.text = strServingPerson;
                }
            }
            else
            {
                //insert
                TableTaking *tableTaking = [[TableTaking alloc]initWithCustomerTableID:customerTable.customerTableID servingPerson:[txtServingPerson.text integerValue] status:1];
                [TableTaking addObject:tableTaking];
                [self.homeModel insertItems:dbTableTaking withData:tableTaking actionScreen:@"insert serving person in order taking screen"];
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
        frame.size.width = (self.view.frame.size.width/3-8)/2;
        btnMoveToTrashAll.frame = frame;
        [self setImageAndTitleCenter:btnMoveToTrashAll];
        
    }
    {
        CGRect frame = btnSendToKitchen.frame;
        frame.size.width = (self.view.frame.size.width/3-8)/2;
        frame.origin.x = frame.size.width + 8;
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
}

- (void)setImageAndTitleCenter:(UIButton *)button
{
    // the space between the image and text
    CGFloat spacing = 6.0;
    
    // lower the text and push it left so it appears centered
    //  below the image
    CGSize imageSize = button.imageView.image.size;
    button.titleEdgeInsets = UIEdgeInsetsMake(
                                              0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    
    // raise the image and push it right so it appears centered
    //  above the text
    CGSize titleSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: button.titleLabel.font}];
    button.imageEdgeInsets = UIEdgeInsetsMake(
                                              - (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
    
    // increase the content height to avoid clipping
    CGFloat edgeOffset = fabsf(titleSize.height - imageSize.height) / 2.0;
    button.contentEdgeInsets = UIEdgeInsetsMake(edgeOffset, 0.0, edgeOffset, 0.0);
}

- (void)loadView
{
    [super loadView];
    txtServingPerson.delegate = self;
    txtTableName.delegate = self;
    _blinkColor = [UIColor clearColor];
    _selectedOrderAdjustItem = -1;
    

    [self setShadow:colVwOrderAdjust];
    [self setShadow:colVwMenuWithTakeAway];
    [self setCornerAndShadow:btnMoveToTrashAll];
    [self setCornerAndShadow:btnSendToKitchen];

    
    [self loadViewProcess];
}

- (void)loadViewProcess
{
    //customer table section
    txtTableName.text = customerTable.tableName;
    TableTaking *tableTakingExist = [TableTaking getTableTakingWithCustomerTableID:customerTable.customerTableID status:1];
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
        MenuType *menuType = _menuTypeList[0];
        _menuList = [Menu getMenuListWithMenuTypeID:menuType.menuTypeID status:1];
        _menuList = [Menu reorganizeToTwoColumn:_menuList];
    }
    else
    {
        _menuList = [[NSMutableArray alloc]init];
    }
    
    
    //order taking section
    [self reloadOrderTaking];
    
}

- (void)updateTotalOrderAndAmount
{
    
    //cal and show total order and total amount
    NSString *strTotalOrder = [Utility formatDecimal:[OrderTaking getTotalQuantity:_orderTakingList] withMinFraction:0 andMaxFraction:0];
    lblTotalOrderFigure.text = strTotalOrder;
    
    
    NSString *strTotalAmount = [Utility formatDecimal:[OrderTaking getTotalAmount:_orderTakingList] withMinFraction:0 andMaxFraction:2];
    lblTotalAmountFigure.text = [NSString stringWithFormat:@"฿%@",strTotalAmount];
}

- (void)reloadOrderTaking
{
    _orderTakingList = [OrderTaking getOrderTakingListWithCustomerTableID:customerTable.customerTableID status:1];
    
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
    
    
    [self updateTotalOrderAndAmount];
    [colVwOrderAdjust reloadData];
}

- (void) orientationChanged:(NSNotification *)note
{
    if([tbvNote isDescendantOfView:self.view])
    {
        tbvNote.center = CGPointMake(self.view.frame.size.height/2, self.view.frame.size.width/2);
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
    
    
    
    // Do any additional setup after loading the view.
    colVwOrderAdjust.delegate = self;
    colVwOrderAdjust.dataSource = self;
    colVwTabMenuType.delegate = self;
    colVwTabMenuType.dataSource = self;
    colVwMenuWithTakeAway.delegate = self;
    colVwMenuWithTakeAway.dataSource = self;
    
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierOrderAdjustHeader bundle:nil];
        [colVwOrderAdjust registerNib:nib forCellWithReuseIdentifier:reuseIdentifierOrderAdjustHeader];
    }
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
        [[NSBundle mainBundle] loadNibNamed:@"TableViewNote" owner:self options:nil];
        tbvNote.delegate = self;
        tbvNote.dataSource = self;
        CGRect frame = tbvNote.frame;
        frame.size.width = 256;
        frame.size.height = 400;
        tbvNote.frame = frame;
        tbvNote.backgroundColor = [UIColor whiteColor];
        [tbvNote setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
        [self setShadow:tbvNote radius:8];
        
        
        
        //add close button
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0,0, tbvNote.frame.size.width, 40)];
        headerView.backgroundColor = [UIColor whiteColor];
        tbvNote.tableHeaderView = headerView;
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0,12, 160, 25)];
        title.text = @"   เพิ่มหมายเหตุ";
        title.textColor = [UIColor blackColor];
        title.font = [UIFont boldSystemFontOfSize:14.0];
        [headerView addSubview:title];
        UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnClose.frame = CGRectMake(tbvNote.frame.size.width-25-3,12, 25, 25);
        btnClose.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
        btnClose.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [btnClose setTitle:@"X" forState:UIControlStateNormal];
        [btnClose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnClose setBackgroundColor:mBlueColor];
        
        [btnClose addTarget:self action:@selector(closeNote:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:btnClose];
        
        
//        [[NSBundle mainBundle] loadNibNamed:@"ConfirmAndCancelView" owner:self options:nil];
//        //add ยืนยัน กับ ยกเลิก button
////        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0,0, tbvNote.frame.size.width, 44)];
////        footerView.backgroundColor = [UIColor whiteColor];
//        tbvNote.tableFooterView = vwConfirmAndCancel;
//        
//        [vwConfirmAndCancel.btnConfirm addTarget:self action:@selector(closeNote:) forControlEvents:UIControlEventTouchUpInside];

    }
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    [colVwTabMenuType selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture setCancelsTouchesInView:NO];
    
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToCustomerTable" sender:self];
}

- (IBAction)moveToTrashAll:(id)sender
{
    [self closeNote:nil];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:
     [UIAlertAction actionWithTitle:@"ลบรายการทั้งหมด"
                              style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
      {
          //delete serving person, order list and note list, first validate each if fail return otherwise delete each one.
          TableTaking *tableTaking = [TableTaking getTableTakingWithCustomerTableID:customerTable.customerTableID status:1];
          if(tableTaking)
          {
              //delete
              if(!tableTaking.idInserted)
              {
                  [self showAlertAndCallPushSync:@"" message:@"ลบรายการทั้งหมดไม่ได้ กรุณาลองใหม่อีกครั้ง"];
                  return;
              }
          }
          
          
          
          for(OrderTaking *item in _orderTakingList)
          {
              if(!item.idInserted)
              {
                  [self showAlertAndCallPushSync:@"" message:@"ลบรายการทั้งหมดไม่ได้ กรุณาลองใหม่อีกครั้ง"];
                  return;
              }
          }
          
          
          
          NSMutableArray *orderNoteList = [OrderNote getOrderNoteListWithCustomerTableID:customerTable.customerTableID];
          for(OrderNote *item in orderNoteList)
          {
              if(!item.idInserted)
              {
                  [self showAlertAndCallPushSync:@"" message:@"ลบรายการทั้งหมดไม่ได้ กรุณาลองใหม่อีกครั้ง"];
                  return;
              }
          }
          
          
          //after validate success
          //delete serving person
          if(tableTaking)
          {
              txtServingPerson.text = @"";
              [TableTaking removeObject:tableTaking];
              [self.homeModel deleteItems:dbTableTaking withData:tableTaking actionScreen:@"Delete serving person from move to trash all in order taking screen"];
          }
          
        
          
          //ลบรายการที่สั่ง
          if([_orderTakingList count] > 0)
          {
              [OrderTaking removeList:_orderTakingList];
              [self.homeModel deleteItems:dbOrderTakingList withData:_orderTakingList actionScreen:@"Delete order taking list from move to trash all in order taking screen"];
              
          }
          
          
          
          //ลบ note ทั้งหมด
          if([orderNoteList count] > 0)
          {
              [OrderNote removeList:orderNoteList];
              [self.homeModel deleteItems:dbOrderNoteList withData:orderNoteList actionScreen:@"Delete note all from move to trash in order taking screen"];
          }
          
          
          [self reloadOrderTaking];
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
    [self closeNote:nil];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:
     [UIAlertAction actionWithTitle:@"ส่งรายการไปที่ครัว"
                              style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
      {
          //check idinserted
          for(OrderTaking *item in _orderTakingList)
          {
              if(!item.idInserted)
              {
                  [self showAlertAndCallPushSync:@"" message:@"ไม่สามารถส่งรายการไปที่ครัวได้ กรุณาลองใหม่อีกครั้ง"];
                  return;
              }
          }
          
          //call rearrange first (to sum up duplicate record(remove and update ordertaking))
          [self reaarangeOrderWithUpdateOrderTakingListInDB:NO];//เพราะมา update ที่ method นี้อยู่แล้วตอนท้าย
          
          
          //add to orderkitchen
          NSInteger sequenceNo = [OrderKitchen getNextSequenceNo];
          NSMutableArray *orderKitchenList = [[NSMutableArray alloc]init];
          for(OrderTaking *item in _orderTakingList)
          {
              OrderKitchen *orderKitchen = [[OrderKitchen alloc]initWithCustomerTableID:customerTable.customerTableID orderTakingID:item.orderTakingID sequenceNo:sequenceNo];
              [orderKitchenList addObject:orderKitchen];
          }
          [self.homeModel insertItems:dbOrderKitchenList withData:orderKitchenList actionScreen:@"insert order kitchen from send to kitchen in order taking screen"];
          
          
          
          //update ordertakinglist
          for(OrderTaking *item in _orderTakingList)
          {
              item.status = 2;
              item.modifiedUser = [Utility modifiedUser];
              item.modifiedDate = [Utility currentDateTime];
          }
          
          [self.homeModel updateItems:dbOrderTakingList withData:_orderTakingList actionScreen:@"update status of ordertaking from send to kitchen in order taking screen"];
          
          

          [self performSegueWithIdentifier:@"segUnwindToCustomerTable" sender:self];
      }]];
    [alert addAction:
     [UIAlertAction actionWithTitle:@"ยกเลิก"
                              style:UIAlertActionStyleCancel
                            handler:^(UIAlertAction *action) {}]];
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        [alert setModalPresentationStyle:UIModalPresentationPopover];
        
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        CGRect frame = btnSendToKitchen.bounds;
        frame.origin.y = frame.origin.y-15;
        popPresenter.sourceView = btnSendToKitchen;
        popPresenter.sourceRect = frame;
    }
    
    [self presentViewController:alert animated:YES completion:nil];

}

- (IBAction)rearrangeOrder:(id)sender
{
    [self closeNote:nil];
    [self reaarangeOrderWithUpdateOrderTakingListInDB:YES];
    [self reloadOrderTaking];
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
    return  1;
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
        return [_menuList count];
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSInteger item = indexPath.item;
    if([collectionView isEqual:colVwOrderAdjust])
    {
        CustomCollectionViewCellOrderAdjust *cell = (CustomCollectionViewCellOrderAdjust*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierOrderAdjust forIndexPath:indexPath];
        
        
        cell.contentView.userInteractionEnabled = NO;
        if(item == _selectedOrderAdjustItem)
        {
            cell.backgroundColor = mLightGrayColor;
        }
        else
        {
            cell.backgroundColor = [UIColor clearColor];
        }
        
        
        
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
        
        
        CGSize menuNameLabelSize = [self suggestedSizeWithFont:cell.lblMenuName.font size:CGSizeMake(self.view.frame.size.width/3 - 153, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:cell.lblMenuName.text];//153 from storyboard
        CGRect frame = cell.lblMenuName.frame;
        frame.size.width = menuNameLabelSize.width;
        frame.size.height = menuNameLabelSize.height;
        cell.lblMenuName.frame = frame;
        
        
        
        //note
        cell.lblNote.text = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID];
        
        
        
        CGSize noteLabelSize = [self suggestedSizeWithFont:cell.lblNote.font size:CGSizeMake(self.view.frame.size.width/3 - 153, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:cell.lblNote.text];
        CGRect frame2 = cell.lblNote.frame;
        frame2.size.width = noteLabelSize.width;
        frame2.size.height = noteLabelSize.height;
        cell.lblNote.frame = frame2;


        
        //total price
        NSString *strTotalPrice = [Utility formatDecimal:orderTaking.quantity*orderTaking.price withMinFraction:0 andMaxFraction:0];
        cell.lblTotalPrice.text = [NSString stringWithFormat:@"฿%@",strTotalPrice];
        
        
        //quantity
        NSString *strQuantity = [Utility formatDecimal:orderTaking.quantity withMinFraction:0 andMaxFraction:0];
        cell.lblQuantity.text = strQuantity;
        
        
        //add note
        cell.btnAddNote.tag = item;//orderTaking.orderTakingID;
        [cell.btnAddNote addTarget:self action:@selector(addNoteTouchDown:) forControlEvents:UIControlEventTouchDown];
        [cell.btnAddNote addTarget:self action:@selector(addNote:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //move to trash
        cell.btnMoveToTrash.tag = item;//orderTaking.orderTakingID;
        [cell.btnMoveToTrash addTarget:self action:@selector(moveToTrashTouchDown:) forControlEvents:UIControlEventTouchDown];
        [cell.btnMoveToTrash addTarget:self action:@selector(moveToTrash:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //increment
        cell.btnIncrement.tag = item;//orderTaking.orderTakingID;
        [cell.btnIncrement addTarget:self action:@selector(incrementTouchDown:) forControlEvents:UIControlEventTouchDown];
        [cell.btnIncrement addTarget:self action:@selector(increment:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //decrement
        cell.btnDecrement.tag = item;//orderTaking.orderTakingID;
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
        
        Menu *menu = _menuList[item];
        //click menu
        cell.btnMenuName.tag = item;
        [cell.btnMenuName setTitle:menu.titleThai forState:UIControlStateNormal];
        [cell.btnMenuName addTarget:self action:@selector(addOrderTouchDown:) forControlEvents:UIControlEventTouchDown];
        [cell.btnMenuName addTarget:self action:@selector(addOrder:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //take away
        cell.btnTakeAway.tag = menu.menuID;
        [cell.btnTakeAway addTarget:self action:@selector(takeAwayTouchDown:) forControlEvents:UIControlEventTouchDown];
        [cell.btnTakeAway addTarget:self action:@selector(takeAway:) forControlEvents:UIControlEventTouchUpInside];
        
        
        return cell;
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([collectionView isEqual:colVwTabMenuType])
    {
        [self closeNote:nil];
        
        
        _selectedIndexMenuType = indexPath.item;
        
        
        CustomCollectionViewCellTabMenuType * cell = (CustomCollectionViewCellTabMenuType *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.vwBottomBorder.hidden = YES;
        cell.lblMenuType.font = [UIFont boldSystemFontOfSize:15.0f];
        cell.backgroundColor = mLightBlueColor;
        cell.lblMenuType.textColor = mBlueColor;
        
        
        MenuType *menuType = _menuTypeList[_selectedIndexMenuType];
        _menuList = [Menu getMenuListWithMenuTypeID:menuType.menuTypeID status:1];
        _menuList = [Menu reorganizeToTwoColumn:_menuList];
        [colVwMenuWithTakeAway reloadData];
    }
    else if([collectionView isEqual:colVwOrderAdjust])
    {
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
        CustomCollectionViewCellOrderAdjust * cell = (CustomCollectionViewCellOrderAdjust *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
    }
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
    
    CGSize size;
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
        
        
        UIFont *fontMenuName = [UIFont systemFontOfSize:14.0];
        UIFont *fontNote = [UIFont systemFontOfSize:11.0];
        
        
        CGSize menuNameLabelSize = [self suggestedSizeWithFont:fontMenuName size:CGSizeMake(self.view.frame.size.width/3 - 153, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:strMenuName];//153 from storyboard
        CGSize noteLabelSize = [self suggestedSizeWithFont:fontNote size:CGSizeMake(self.view.frame.size.width/3 - 153, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:@"ไม่พริก ไม่งอก ไม่เส้น ไม่เค็ม"];
        
        
        float height = menuNameLabelSize.height+noteLabelSize.height+13*2;
        if(height <= (39+30+13))
        {
            height = (39+30+13);
        }
        size = CGSizeMake(colVwOrderAdjust.frame.size.width,height);
    }
    else if([collectionView isEqual:colVwTabMenuType])
    {
        float row = 2;
        NSInteger column = ceil([_menuTypeList count]/row);
        size = CGSizeMake(colVwTabMenuType.frame.size.width/column,colVwTabMenuType.frame.size.height/row);
    }
    else// if([collectionView isEqual:colVwMenuWithTakeAway])
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

- (void)addOrderTouchDown:(id)sender
{
    UIButton *button = sender;
    [button setTitleColor:mBlueColor forState:UIControlStateNormal];
    double delayInSeconds = 0.3;//delay 1.3 เพราะไม่อยากให้กดเบิ้ล(กด insert และ update ด้วยปุ่มเดิม) หน่วงเพื่อหลอกตา แต่ว่ามีเช็ค idinserted เผื่อไว้อยู่แล้ว จะใช้ 0.3 กรณีที่ไม่ได้ต้องกดต่อเนื่อง คือ insert แล้ว update หรือ delete โดยใช้ปุ่มเดิม
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [button setTitleColor:mDarkGrayColor forState:UIControlStateNormal];
    });
}

- (void)addOrder:(id)sender
{
    [self closeNote:nil];
    
    
    UIButton *button = sender;
    NSInteger item = button.tag;
    Menu *menu = _menuList[item];
    
    OrderTaking *orderTakingExist = [OrderTaking getOrderTakingWithCustomerTableID:customerTable.customerTableID menuID:menu.menuID takeAway:0 noteIDListInText:@"" status:1];
    
    //update
    if(orderTakingExist)
    {
        if(orderTakingExist.idInserted)
        {
            orderTakingExist.quantity += 1;
            orderTakingExist.modifiedUser = [Utility modifiedUser];
            orderTakingExist.modifiedDate = [Utility currentDateTime];
            [self.homeModel updateItems:dbOrderTaking withData:orderTakingExist actionScreen:@"click menu in order taking screen"];
            
            
            [self reloadOrderTaking];
            
            
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
                _blinkColor = mLightGrayColor;
                [self collectionView:colVwOrderAdjust didSelectItemAtIndexPath:indexPath];
            });
        }
        else
        {
            [self showAlertAndCallPushSync:@"" message:@"เพิ่มรายการไม่ได้ กรุณาลองใหม่อีกครั้ง"];
        }
    }
    else
    {
        OrderTaking *orderTaking = [[OrderTaking alloc]initWithCustomerTableID:customerTable.customerTableID menuID:menu.menuID quantity:1 specialPrice:0 price:menu.price takeAway:0 noteIDListInText:@"" orderNo:0 status:1 receiptID:0];
        [OrderTaking addObject:orderTaking];
        [self.homeModel insertItems:dbOrderTaking withData:orderTaking actionScreen:@"click menu in order taking screen"];
        
        [self reloadOrderTaking];
        
        
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
        [button setImage:[UIImage imageNamed:@"Take away"] forState:UIControlStateNormal];
    });
}

- (void)takeAway:(id)sender
{
    [self closeNote:nil];
    
    
    UIButton *button = sender;
    NSInteger menuID = button.tag;
    Menu *menu = [Menu getMenu:menuID];
    
    OrderTaking *orderTakingExist = [OrderTaking getOrderTakingWithCustomerTableID:customerTable.customerTableID menuID:menuID takeAway:1 noteIDListInText:@"" status:1];
    if(orderTakingExist)
    {
        if(orderTakingExist.idInserted)
        {
            orderTakingExist.quantity += 1;
            orderTakingExist.modifiedUser = [Utility modifiedUser];
            orderTakingExist.modifiedDate = [Utility currentDateTime];
            [self.homeModel updateItems:dbOrderTaking withData:orderTakingExist actionScreen:@"click menu in order taking screen"];
            
            
            [self reloadOrderTaking];
            
            
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
                _blinkColor = mLightGrayColor;
                [self collectionView:colVwOrderAdjust didSelectItemAtIndexPath:indexPath];
            });

        }
        else
        {
            [self showAlertAndCallPushSync:@"" message:@"เพิ่มรายการไม่ได้ กรุณาลองใหม่อีกครั้ง"];
        }
    }
    else
    {
        OrderTaking *orderTaking = [[OrderTaking alloc]initWithCustomerTableID:customerTable.customerTableID menuID:menuID quantity:1 specialPrice:0 price:menu.price takeAway:1 noteIDListInText:@"" orderNo:0 status:1 receiptID:0];
        [OrderTaking addObject:orderTaking];
        [self.homeModel insertItems:dbOrderTaking withData:orderTaking actionScreen:@"click menu in order taking screen"];
        
        
        [self reloadOrderTaking];
        
        
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
    
    
    //show note box to select
    tbvNote.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [tbvNote reloadData];
    
    {
        tbvNote.alpha = 0.0;
        [self.view addSubview:tbvNote];
        [UIView animateWithDuration:0.2 animations:^{
            tbvNote.alpha = 1.0;
        }];
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
    CustomCollectionViewCellOrderAdjust *cell = (CustomCollectionViewCellOrderAdjust *)[colVwOrderAdjust cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = mLightGrayColor;
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
    [self closeNote:nil];
    
    
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
                                  if(!orderTaking.idInserted)
                                  {
                                      [self showAlertAndCallPushSync:@"" message:@"ลบรายการไม่ได้ กรุณาลองใหม่อีกครั้ง"];
                                      return;
                                  }
                                  
                                  
                                  NSMutableArray *orderNoteList = [OrderNote getNoteListWithOrderTakingID:orderTaking.orderTakingID];
                                  for(OrderNote *item in orderNoteList)
                                  {
                                      if(!item.idInserted)
                                      {
                                          return;
                                      }
                                  }
                                  
                                  
                                  //remove ordertaking
                                  [OrderTaking removeObject:orderTaking];
                                  [self.homeModel deleteItems:dbOrderTaking withData:orderTaking actionScreen:@"Remove order in order taking screen"];
                                  
                                  
                                  //remove ordernote
                                  [OrderNote removeList:orderNoteList];
                                  [self.homeModel deleteItems:dbOrderNoteList withData:orderNoteList actionScreen:@"Remove order note from move to trash in order taking screen"];
                                  
                                  
                                  [self reloadOrderTaking];
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
    [self closeNote:nil];
    
    
    UIButton *button = sender;
    NSInteger item = button.tag;
    OrderTaking *orderTaking = _orderTakingList[item];
    
    
    if(orderTaking.idInserted)
    {
        orderTaking.quantity += 1;
        orderTaking.modifiedUser = [Utility modifiedUser];
        orderTaking.modifiedDate = [Utility currentDateTime];
        [self.homeModel updateItems:dbOrderTaking withData:orderTaking actionScreen:@"increment order in order taking screen"];
        
        
        
        //update display quantity and total price
        CustomCollectionViewCellOrderAdjust *cell = (CustomCollectionViewCellOrderAdjust *)[colVwOrderAdjust cellForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0]];
        cell.lblQuantity.text = [Utility formatDecimal:orderTaking.quantity withMinFraction:0 andMaxFraction:0];
        cell.lblTotalPrice.text = [Utility formatDecimal:orderTaking.quantity*orderTaking.price withMinFraction:0 andMaxFraction:0];
        
        
        //update total order and total amount
        [self updateTotalOrderAndAmount];
    }
    else
    {
        [self showAlertAndCallPushSync:@"" message:@"เพิ่มจำนวนรายการไม่ได้ กรุณาลองใหม่อีกครั้ง"];
    }
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
    [self closeNote:nil];
    
    
    UIButton *button = sender;
    NSInteger item = button.tag;
    OrderTaking *orderTaking = _orderTakingList[item];
    
    
    if(orderTaking.idInserted)
    {
        if(orderTaking.quantity == 1)
        {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleActionSheet];
            [alert addAction:
             [UIAlertAction actionWithTitle:@"ลบรายการ"
                                      style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
              {
                  [OrderTaking removeObject:orderTaking];
                  [self.homeModel deleteItems:dbOrderTaking withData:orderTaking actionScreen:@"remove order in order taking screen"];
                  
                  
                  [self reloadOrderTaking];//update เฉพาะ cell ลำบาก เนืองจากเป็นการ remove cell เลยเรียก colvw reload ไปเลย
                  
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
            [self.homeModel updateItems:dbOrderTaking withData:orderTaking actionScreen:@"increment order in order taking screen"];
            
            
            //ไม่เรียก colvw reload เพราะมันจะ decrement touch down ผิด cell เลย update เฉพาะ cell ที่แก้ไขไป
            //update display quantity and total price
            CustomCollectionViewCellOrderAdjust *cell = (CustomCollectionViewCellOrderAdjust *)[colVwOrderAdjust cellForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0]];
            cell.lblQuantity.text = [Utility formatDecimal:orderTaking.quantity withMinFraction:0 andMaxFraction:0];
            cell.lblTotalPrice.text = [Utility formatDecimal:orderTaking.quantity*orderTaking.price withMinFraction:0 andMaxFraction:0];
            
            
            //update total order and total amount
            [self updateTotalOrderAndAmount];
        }
    }
    else
    {
        [self showAlertAndCallPushSync:@"" message:@"ลดจำนวนรายการไม่ได้ กรุณาลองใหม่อีกครั้ง"];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.

    return [_noteList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        
    }
    
    NSInteger item = indexPath.item;
    
    if(tableView == tbvNote)
    {
        Note *note = _noteList[item];
        OrderTaking *orderTaking = _orderTakingList[_selectedOrderAdjustItem];
        OrderNote *orderNote = [OrderNote getOrderNoteWithOrderTakingID:orderTaking.orderTakingID noteID:note.noteID];
        
        if(orderNote)
        {
            cell.textLabel.text = [NSString stringWithFormat:@"✔️ %@",note.name];
        }
        else
        {
            cell.textLabel.text = [NSString stringWithFormat:@"      %@",note.name];
        }
        
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        
        
        NSString *strNotePrice = @"";
        if(note.price > 0)
        {
            strNotePrice = [NSString stringWithFormat:@"+%@",[Utility formatDecimal:note.price withMinFraction:0 andMaxFraction:0]];
        }
        else if (note.price < 0)
        {
            strNotePrice = [NSString stringWithFormat:@"-%@",[Utility formatDecimal:note.price withMinFraction:0 andMaxFraction:0]];
        }
        cell.detailTextLabel.text = strNotePrice;
        cell.detailTextLabel.textColor = [UIColor blackColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        
    }
    
    return cell;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
    [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];

    [cell setLayoutMargins:UIEdgeInsetsMake(16, 16, 16, 16)];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger item = indexPath.item;
    Note *note = _noteList[item];
    OrderTaking *orderTaking = _orderTakingList[_selectedOrderAdjustItem];
    OrderNote *orderNoteExist = [OrderNote getOrderNoteWithOrderTakingID:orderTaking.orderTakingID noteID:note.noteID];
    
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"✔️ %@", note.name];
    
    
    //insert
    if(!orderNoteExist)//เช็คสำหรับกรณี deselect มาเรียกตอน idinserted ยังไม่พร้อม
    {
        if(orderTaking.idInserted)
        {
            //inset note
            OrderNote *orderNote = [[OrderNote alloc]initWithOrderTakingID:orderTaking.orderTakingID noteID:note.noteID];
            [OrderNote addObject:orderNote];
            [self.homeModel insertItems:dbOrderNote withData:orderNote actionScreen:@"Select note for order"];
            
            
            
            //update note id list in text
            orderTaking.noteIDListInText = [OrderNote getNoteIDListInTextWithOrderTakingID:orderTaking.orderTakingID];
            
            
            //update ordertaking price
            Menu *menu = [Menu getMenu:orderTaking.menuID];
            float sumNotePrice = [OrderNote getSumNotePriceWithOrderTakingID:orderTaking.orderTakingID];
            orderTaking.price = menu.price+sumNotePrice;
            orderTaking.modifiedUser = [Utility modifiedUser];
            orderTaking.modifiedDate = [Utility currentDateTime];
            
            
            [self.homeModel updateItems:dbOrderTaking withData:orderTaking actionScreen:@"Add note and price in order taking when select note"];
            
            
            [self reloadOrderTaking];

        }
        else
        {
            [tbvNote deselectRowAtIndexPath:indexPath animated:YES];
            [self showAlertAndCallPushSync:@"" message:@"เพิ่มโน้ตไม่ได้ กรุณาลองใหม่อีกครั้ง"];
            return;
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger item = indexPath.item;
    Note *note = _noteList[item];
    OrderTaking *orderTaking = _orderTakingList[_selectedOrderAdjustItem];
    OrderNote *orderNote = [OrderNote getOrderNoteWithOrderTakingID:orderTaking.orderTakingID noteID:note.noteID];
    
    
    //delete
    if(orderNote)
    {
        if(orderNote.idInserted)
        {
            //delete ordernote
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.textLabel.text = [NSString stringWithFormat:@"      %@", note.name];
            
            
            [OrderNote removeObject:orderNote];
            [self.homeModel deleteItems:dbOrderNote withData:orderNote actionScreen:@"Unselect note for order"];
            
            
            
            
            //ไม่ต้องเช็ค idinserted ของ ordertaking เพราะ ผ่านการ select note มาแล้วคืือ ordertaking ต้องถูก update มาแล้วแน่นอน
            //update ordertaking note id list in text
            orderTaking.noteIDListInText = [OrderNote getNoteIDListInTextWithOrderTakingID:orderTaking.orderTakingID];
            
            
            
            //update ordertaking price
            Menu *menu = [Menu getMenu:orderTaking.menuID];
            float sumNotePrice = [OrderNote getSumNotePriceWithOrderTakingID:orderTaking.orderTakingID];
            orderTaking.price = menu.price+sumNotePrice;
            orderTaking.modifiedUser = [Utility modifiedUser];
            orderTaking.modifiedDate = [Utility currentDateTime];
            
            [self.homeModel updateItems:dbOrderTaking withData:orderTaking actionScreen:@"Remove note and price in order taking when select note"];
            
            
            [self reloadOrderTaking];
        }
        else
        {
            [tbvNote selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            [self showAlertAndCallPushSync:@"" message:@"แก้ไขหมายเหตุไม่ได้ กรุณาลองใหม่อีกครั้ง"];
            return;
        }
    }
}

- (void)closeNote:(id)sender
{
    [tbvNote removeFromSuperview];
    

    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedOrderAdjustItem inSection:0];
    CustomCollectionViewCellOrderAdjust *cell = (CustomCollectionViewCellOrderAdjust *)[colVwOrderAdjust cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    _selectedOrderAdjustItem = -1;
}


@end
