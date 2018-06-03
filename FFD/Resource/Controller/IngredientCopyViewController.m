//
//  IngredientCopyViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/20/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "IngredientCopyViewController.h"
#import "CustomCollectionViewCellTabMenuType.h"
#import "CustomCollectionViewCellAddAddress.h"
#import "CustomCollectionViewCellMenuWithTakeAway.h"
#import "CustomCollectionReusableView.h"
#import "CustomTableViewCell.h"
#import "NDCollectionViewFlowLayout.h"
#import "MenuType.h"
#import "Menu.h"
#import "SubMenuType.h"
#import "MenuIngredient.h"
#import "IngredientType.h"
#import "Ingredient.h"
#import "OrderTaking.h"
#import "Utility.h"
#import "MenuTypeViewController.h"
#import "MenuMasterViewController.h"
#import "SubMenuTypeViewController.h"
#import "SubMenuTypeReorderViewController.h"
#import "IngredientSetUpViewController.h"



@interface IngredientCopyViewController ()
{
    NSMutableArray *_menuTypeList;
    NSMutableArray *_subMenuTypeList;
    NSMutableArray *_arrOfMenuList;
    NSMutableArray *_emptyMenuList;
    NSInteger _selectedIndexMenuType;
    NSInteger _selectedIndexMenu;
    Menu *_selectedMenu;
    NSMutableArray *_menuIngredientList;
    NSMutableArray *_arrOfIngredientList;
    NSMutableArray *_ingredientTypeList;
    NSIndexPath *_selectedMenuIP;
    Menu *_editMenu;
    
}
@end

@implementation IngredientCopyViewController
static NSString * const reuseHeaderViewIdentifier = @"CustomCollectionReusableView";
static NSString * const reuseIdentifierTabMenuType = @"CustomCollectionViewCellTabMenuType";
static NSString * const reuseIdentifierAddAddress = @"CustomCollectionViewCellAddAddress";
static NSString * const reuseIdentifierMenuWithTakeAway = @"CustomCollectionViewCellMenuWithTakeAway";
static NSString * const reuseIdentifierCustomTableViewCell = @"CustomTableViewCell";


@synthesize colVwTabMenuType;
@synthesize colVwMenuWithTakeAway;
@synthesize vwTop;
@synthesize tbvDetail;
@synthesize btnAddEdit;
@synthesize btnReorder;
@synthesize btnAddEditSubMenu;
@synthesize btnReorderSubMenu;
@synthesize btnShowAll;
@synthesize btnShowAllSubMenu;
@synthesize editMenu;
@synthesize lblMenu;
@synthesize flagCopyIngredient;
//@synthesize flagCopyMenu;


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    
    {
        CGRect frame = colVwTabMenuType.frame;
        
        frame.origin.x = 0;
        frame.origin.y = 20+50;//20 ให้ถัดจาก top status bar
        frame.size.width = ceil(self.view.frame.size.width/3*2)-8-42;//31 แต่ใช้ 42 เลขจะได้หารลงตัวแบ่ง collectionviewcell ได้ไม่มีจุดทศนิยม
        frame.size.height = 91-20-2;//storyboard reference
        colVwTabMenuType.frame = frame;
    }
    
    {
        CGRect frame = colVwMenuWithTakeAway.frame;
        
        frame.origin.x = 0;
        frame.origin.y = 91+8+50;//storyboard reference+gap
        frame.size.width = ceil(self.view.frame.size.width/3*2)-8-42;
        frame.size.height = self.view.frame.size.height-91-8-50;//50 for back button
        colVwMenuWithTakeAway.frame = frame;
    }
    
    {
        CGRect frame = vwTop.frame;
        
        frame.origin.x = colVwTabMenuType.frame.origin.x + colVwTabMenuType.frame.size.width + 8;
        frame.origin.y = 20;
        frame.size.width = self.view.frame.size.width - colVwMenuWithTakeAway.frame.size.width - 8;
        frame.size.height = 91-20+50;
        vwTop.frame = frame;
    }
    
    {
        CGRect frame = tbvDetail.frame;
        
        frame.origin.x = colVwTabMenuType.frame.origin.x + colVwTabMenuType.frame.size.width + 8;
        frame.origin.y = 91+8+50;//storyboard reference+gap
        frame.size.width = self.view.frame.size.width - colVwMenuWithTakeAway.frame.size.width - 8;
        frame.size.height = self.view.frame.size.height-91-8-50;
        tbvDetail.frame = frame;
    }
}

- (void)loadView
{
    [super loadView];
    
    _selectedIndexMenuType = 0;
    _selectedIndexMenu = -1;
    _arrOfMenuList = [[NSMutableArray alloc]init];
    _emptyMenuList = [[NSMutableArray alloc]init];
    _arrOfIngredientList = [[NSMutableArray alloc]init];
    _ingredientTypeList = [[NSMutableArray alloc]init];
    btnAddEdit.enabled = NO;
    colVwMenuWithTakeAway.collectionViewLayout = [[NDCollectionViewFlowLayout alloc]init];
    colVwTabMenuType.collectionViewLayout = [[NDCollectionViewFlowLayout alloc]init];
    [colVwMenuWithTakeAway setContentOffset:CGPointMake(0, 0)];
    [btnShowAll setTitle:@"แสดงทั้งหมด" forState:UIControlStateNormal];
    [btnShowAllSubMenu setTitle:@"แสดงทั้งหมด" forState:UIControlStateNormal];
    [btnShowAll setSelected:YES];
    [btnShowAllSubMenu setSelected:YES];
    lblMenu.text = editMenu.titleThai;
    btnAddEdit.hidden = YES;
    btnReorder.hidden = YES;
    btnAddEditSubMenu.hidden = YES;
    btnReorderSubMenu.hidden = YES;

    
    
    
    tbvDetail.delegate = self;
    tbvDetail.dataSource = self;
    
    
    [self setShadow:colVwMenuWithTakeAway];
    [self setShadow:tbvDetail];
    [self loadViewProcess];
}

- (void)loadViewProcess
{
    //menu section
    if(btnShowAll.selected)//เฉพาะที่ใช้อยู่
    {
        _menuTypeList = [MenuType getMenuTypeListWithStatus:1];
    }
    else
    {
        _menuTypeList = [MenuType getMenuTypeList];
    }
    if(_selectedIndexMenuType > [_menuTypeList count] - 1)//กรณีลบ menutype
    {
        _selectedIndexMenuType -= 1;
    }
    [colVwTabMenuType reloadData];
    
    
    
    if([_menuTypeList count]>0)
    {
        [self selectMenuType];
    }
    else
    {
        [_arrOfMenuList removeAllObjects];
        [_arrOfMenuList addObject:_emptyMenuList];
    }
    btnShowAll.enabled = YES;
    
    
    
    
    
    //ถ้า _selectedMenu not in _arrOfMenuList ให้ selectedMenu = nil
    int doBreak = 0;
    for(NSMutableArray *menuList in _arrOfMenuList)
    {
        for(Menu *item in menuList)
        {
            if([item isEqual:_selectedMenu])
            {
                doBreak = 1;
                break;
            }
        }
        if(doBreak)
        {
            break;
        }
    }
    if(!doBreak)
    {
        _selectedMenu = nil;
    }
    
    [self setMenuIngredient];
    
    
    
    if([_subMenuTypeList count] > 0 && [_menuTypeList count] > 0)
    {
        btnAddEditSubMenu.enabled = YES;
    }
    else
    {
        btnAddEditSubMenu.enabled = NO;
    }
}

- (void)selectMenuType
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedIndexMenuType inSection:0];
    [colVwTabMenuType selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    
    
    
    [_arrOfMenuList removeAllObjects];
    _selectedIndexMenuType = _selectedIndexMenuType>=[_menuTypeList count]?[_menuTypeList count]-1:_selectedIndexMenuType;
    MenuType *menuType = _menuTypeList[_selectedIndexMenuType];
    if(btnShowAllSubMenu.selected)
    {
        _subMenuTypeList = [SubMenuType getSubMenuTypeListWithMenuTypeID:menuType.menuTypeID status:1];
    }
    else
    {
        _subMenuTypeList = [SubMenuType getSubMenuTypeListWithMenuTypeID:menuType.menuTypeID];
    }
    if([_subMenuTypeList count] == 0)
    {
        [_arrOfMenuList addObject:_emptyMenuList];
    }
    else
    {
        btnShowAll.enabled = YES;
        
        for(SubMenuType *item in _subMenuTypeList)
        {
            if(btnShowAll.selected)//เฉพาะที่ใช้งาน
            {
                NSMutableArray *menuList = [Menu getMenuListWithMenuTypeID:menuType.menuTypeID subMenuTypeID:item.subMenuTypeID status:1];
                [_arrOfMenuList addObject:menuList];
            }
            else
            {
                NSMutableArray *menuList = [Menu getMenuListWithMenuTypeID:menuType.menuTypeID subMenuTypeID:item.subMenuTypeID];
                [_arrOfMenuList addObject:menuList];
            }
        }
    }
    
    
    [colVwMenuWithTakeAway reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectMenuType)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    
    
    // Do any additional setup after loading the view.
    colVwTabMenuType.delegate = self;
    colVwTabMenuType.dataSource = self;
    colVwMenuWithTakeAway.delegate = self;
    colVwMenuWithTakeAway.dataSource = self;
    
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierTabMenuType bundle:nil];
        [colVwTabMenuType registerNib:nib forCellWithReuseIdentifier:reuseIdentifierTabMenuType];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierAddAddress bundle:nil];
        [colVwTabMenuType registerNib:nib forCellWithReuseIdentifier:reuseIdentifierAddAddress];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierMenuWithTakeAway bundle:nil];
        [colVwMenuWithTakeAway registerNib:nib forCellWithReuseIdentifier:reuseIdentifierMenuWithTakeAway];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierAddAddress bundle:nil];
        [colVwMenuWithTakeAway registerNib:nib forCellWithReuseIdentifier:reuseIdentifierAddAddress];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseHeaderViewIdentifier bundle:nil];
        [colVwMenuWithTakeAway registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderViewIdentifier];
    }
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierCustomTableViewCell bundle:nil];
        [tbvDetail registerNib:nib forCellReuseIdentifier:reuseIdentifierCustomTableViewCell];
    }
    
    
    
    if([_menuTypeList count]>0)
    {
        [self selectMenuType];
    }
    
    
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture setCancelsTouchesInView:NO];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger numberOfSection = 1;
    if([collectionView isEqual:colVwTabMenuType])
    {
        numberOfSection = 1;
    }
    else if([collectionView isEqual:colVwMenuWithTakeAway])
    {
        if([_subMenuTypeList count] == 0 && [_menuTypeList count] > 0)
        {
            numberOfSection = 1;
        }
        else
        {
            numberOfSection = [_subMenuTypeList count];
        }
    }
    
    return  numberOfSection;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if([collectionView isEqual:colVwTabMenuType])
    {
        if([_menuTypeList count] == 0)
        {
            return 1;
        }
        else
        {
            return [_menuTypeList count];
        }
    }
    else if([collectionView isEqual:colVwMenuWithTakeAway])
    {
        //load menu มาโชว์
        NSMutableArray *menuList = _arrOfMenuList[section];
        if([menuList count] == 0)
        {
            return 1;
        }
        else
        {
            return [menuList count];
        }
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSInteger item = indexPath.item;
    NSInteger section = indexPath.section;
    
    
    if([collectionView isEqual:colVwTabMenuType])
    {
        if([_menuTypeList count] == 0)
        {
            CustomCollectionViewCellAddAddress *cell = (CustomCollectionViewCellAddAddress *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierAddAddress forIndexPath:indexPath];
            cell.contentView.userInteractionEnabled = NO;
            
            
            [cell.btnAddAddress setTitle:@"เพิ่มหมวดอาหาร" forState:UIControlStateNormal];
            [cell.btnAddAddress addTarget:self action:@selector(addMenuType:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnAddAddress.titleLabel.font = [UIFont systemFontOfSize:15];
            
            
            return cell;
        }
        else
        {
            CustomCollectionViewCellTabMenuType *cell = (CustomCollectionViewCellTabMenuType *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierTabMenuType forIndexPath:indexPath];
            
            
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
    }
    else if([collectionView isEqual:colVwMenuWithTakeAway])
    {
        NSMutableArray *menuList = _arrOfMenuList[section];
        NSInteger subMenuTypeID = -1;
        if([_subMenuTypeList count] > 0)
        {
            SubMenuType *subMenuType = _subMenuTypeList[section];
            subMenuTypeID = subMenuType.subMenuTypeID;
        }
        if([menuList count] == 0)
        {
            CustomCollectionViewCellAddAddress *cell = (CustomCollectionViewCellAddAddress *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierAddAddress forIndexPath:indexPath];
            cell.contentView.userInteractionEnabled = NO;
            
            
            [cell.btnAddAddress setTitle:@"เพิ่มชื่ออาหาร" forState:UIControlStateNormal];
            [cell.btnAddAddress addTarget:self action:@selector(addMenu:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnAddAddress.tag = subMenuTypeID;
            cell.btnAddAddress.titleLabel.font = [UIFont systemFontOfSize:15];
            
            
            return cell;
        }
        else
        {
            CustomCollectionViewCellMenuWithTakeAway *cell = (CustomCollectionViewCellMenuWithTakeAway*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierMenuWithTakeAway forIndexPath:indexPath];
            
            
            
            cell.contentView.userInteractionEnabled = NO;
            NSMutableArray *menuList = _arrOfMenuList[section];
            Menu *menu = menuList[item];
            
            
            //tap menu
            cell.btnMenuName.tag = item;
            [cell.btnMenuName setTitle:menu.titleThai forState:UIControlStateNormal];
            [cell.btnMenuName addTarget:self action:@selector(viewMenuDetailTouchDown:) forControlEvents:UIControlEventTouchDown];
            [cell.btnMenuName addTarget:self action:@selector(viewMenuDetail:) forControlEvents:UIControlEventTouchUpInside];
            
            
            cell.btnTakeAway.hidden = YES;
            if(indexPath == _selectedMenuIP)
            {
                cell.backgroundColor = mLightBlueColor;
                cell.vwRoundedCorner.backgroundColor = mLightBlueColor;
            }
            else
            {
                cell.backgroundColor = [UIColor clearColor];
                cell.vwRoundedCorner.backgroundColor = [UIColor clearColor];
            }
            
            
            return cell;
        }
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([collectionView isEqual:colVwTabMenuType])
    {
        if([_menuTypeList count] > 0)
        {
            _selectedIndexMenuType = indexPath.item;
            
            
            _selectedMenu = nil;
            _selectedIndexMenu = -1;
            _selectedMenuIP = nil;
            [tbvDetail reloadData];
            
            
            
            CustomCollectionViewCellTabMenuType * cell = (CustomCollectionViewCellTabMenuType *)[collectionView cellForItemAtIndexPath:indexPath];
            cell.vwBottomBorder.hidden = YES;
            cell.lblMenuType.font = [UIFont boldSystemFontOfSize:15.0f];
            cell.lblMenuType.textColor = mBlueColor;
            cell.backgroundColor = mLightBlueColor;
            
            
            
            [self selectMenuType];
        }
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
}

#pragma mark <UICollectionViewDelegate>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeMake(0, 0);
    
    if([collectionView isEqual:colVwTabMenuType])
    {
        if([_menuTypeList count] == 0)
        {
            size = CGSizeMake(colVwTabMenuType.frame.size.width,colVwTabMenuType.frame.size.height/2);
        }
        else
        {
            float row = 2;
            NSInteger column = ceil([_menuTypeList count]/row);
            size = CGSizeMake(colVwTabMenuType.frame.size.width/column,colVwTabMenuType.frame.size.height/row);
            NSLog(@"menutype cell: (%ld,%ld) - (%f,%f)",indexPath.section,indexPath.item,size.width,size.height);
        }
    }
    else if([collectionView isEqual:colVwMenuWithTakeAway])
    {
        //load menu มาโชว์
        NSMutableArray *menuList = _arrOfMenuList[indexPath.section];
        if([menuList count] == 0)
        {
            size = CGSizeMake(colVwMenuWithTakeAway.frame.size.width,44);
        }
        else
        {
            size = CGSizeMake(colVwMenuWithTakeAway.frame.size.width/2,44);
        }
    }
    
    
    return size;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    {
        NDCollectionViewFlowLayout *layout = (NDCollectionViewFlowLayout *)colVwTabMenuType.collectionViewLayout;
        
        [layout invalidateLayout];
        [colVwTabMenuType reloadData];
    }
    {
        NDCollectionViewFlowLayout *layout = (NDCollectionViewFlowLayout *)colVwMenuWithTakeAway.collectionViewLayout;
        
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
            headerView.tag = section;

            if(section == 0)
            {
                if([_arrOfMenuList count] > 1)
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
            if([_arrOfMenuList count] > 1)
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
    
    if([collectionView isEqual:colVwMenuWithTakeAway])
    {
        NSMutableArray *menuList = _arrOfMenuList[fromIndexPath.section];
        Menu *menu = menuList[fromIndexPath.item];
        [menuList removeObjectAtIndex:fromIndexPath.item];
        
        
        
        NSMutableArray *menuList2 = _arrOfMenuList[toIndexPath.section];
        [menuList2 insertObject:menu atIndex:toIndexPath.item];
        SubMenuType *subMenuType2 = _subMenuTypeList[toIndexPath.section];
        
        
        
        //check idinserted
        {
            for(Menu *item in menuList2)
            {
                if(!item.idInserted)
                {
                    [self showAlertAndCallPushSync:@"" message:@"ไม่สามารถจัดลำดับชื่ออาหารได้ กรุณาลองใหม่อีกครั้ง"];
                    [self loadingOverlayView];
                    self.homeModel = [[HomeModel alloc]init];
                    self.homeModel.delegate = self;
                    [self.homeModel downloadItems:dbMenu];
                    return;
                }
            }
        }
        
        
        int i=0;
        for(Menu *item in menuList2)
        {
            item.orderNo = i;
            item.subMenuTypeID = subMenuType2.subMenuTypeID;
            item.modifiedUser = [Utility modifiedUser];
            item.modifiedDate = [Utility currentDateTime];
            i++;
        }
        [self.homeModel updateItems:dbMenuList withData:menuList2 actionScreen:@"reorder menu in menu screen"];
    }
    else if([collectionView isEqual:colVwTabMenuType])
    {
        MenuType *menuType = _menuTypeList[fromIndexPath.item];
        [_menuTypeList removeObjectAtIndex:fromIndexPath.item];
        [_menuTypeList insertObject:menuType atIndex:toIndexPath.item];
        
        //check idinserted
        {
            for(MenuType *item in _menuTypeList)
            {
                if(!item.idInserted)
                {
                    [self showAlertAndCallPushSync:@"" message:@"ไม่สามารถจัดลำดับหมวดอาหารได้ กรุณาลองใหม่อีกครั้ง"];
                    [self loadingOverlayView];
                    self.homeModel = [[HomeModel alloc]init];
                    self.homeModel.delegate = self;
                    [self.homeModel downloadItems:dbMenuType];
                    return;
                }
            }
        }
        
        
        
        int i=0;
        for(MenuType *item in _menuTypeList)
        {
            item.orderNo = i;
            item.modifiedUser = [Utility modifiedUser];
            item.modifiedDate = [Utility currentDateTime];
            i++;
        }
        [self.homeModel updateItems:dbMenuTypeList withData:_menuTypeList actionScreen:@"reorder menutype in menu screen"];
    }
}

- (void)viewMenuDetailTouchDown:(id)sender
{
    UIButton *button = sender;
    [button setTitleColor:mBlueColor forState:UIControlStateNormal];
    double delayInSeconds = 0.3;//delay 1.3 เพราะไม่อยากให้กดเบิ้ล(กด insert และ update ด้วยปุ่มเดิม) หน่วงเพื่อหลอกตา แต่ว่ามีเช็ค idinserted เผื่อไว้อยู่แล้ว จะใช้ 0.3 กรณีที่ไม่ได้ต้องกดต่อเนื่อง คือ insert แล้ว update หรือ delete โดยใช้ปุ่มเดิม
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    });
}

- (void)viewMenuDetail:(id)sender
{
//    if(flagCopyMenu)
//    {
//        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:colVwMenuWithTakeAway];
//        NSIndexPath *tappedIP = [colVwMenuWithTakeAway indexPathForItemAtPoint:buttonPosition];
//        NSMutableArray *menuList = _arrOfMenuList[tappedIP.section];
//        Menu *menu = menuList[tappedIP.item];
//        Menu *copyMenu = [menu copy];
//        copyMenu.menuID = [Menu getNextID];
//        copyMenu.menuTypeID = editMenu.menuTypeID;
//        copyMenu.subMenuTypeID = editMenu.subMenuTypeID;
//        [Menu addObject:copyMenu];
//        
//        
//        NSMutableArray *copyMenuIngredientList = [[NSMutableArray alloc]init];
//        NSMutableArray *menuIngredientList = [MenuIngredient getMenuIngredientListWithMenuID:menu.menuID];
//        for(MenuIngredient *item in menuIngredientList)
//        {
//            MenuIngredient *newItem = [item copy];
//            newItem.menuIngredientID = [MenuIngredient getNextID];
//            newItem.menuID = copyMenu.menuID;
//            newItem.idInserted = 0;
//            newItem.replaceSelf = 0;
//            [MenuIngredient addObject:newItem];
//            [copyMenuIngredientList addObject:newItem];
//        }
//        
//        [self.homeModel insertItems:dbMenuAndMenuIngredientList withData:@[copyMenu,copyMenuIngredientList] actionScreen:@"copy menu and menuIngredient in menu screen"];
//        flagCopyIngredient = 1;
//        
//        
//        [self performSegueWithIdentifier:@"segUnwindToMenu" sender:self];
//    }
//    else//copy menuingredient
    {
        //กรณีมีส่วนประกอบอยู่แล้ว ให้แสดงตัวเลือกต้องการ 1.แทนที่ส่วนประกอบเดิม 2.ยกเลิก
        NSMutableArray *editMenuMenuIngredientList = [MenuIngredient getMenuIngredientListWithMenuID:editMenu.menuID];
        if([editMenuMenuIngredientList count]>0)
        {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleActionSheet];
            [alert addAction:
             [UIAlertAction actionWithTitle:@"แทนที่ส่วนประกอบเดิม"
                                      style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
              {
                  [self copyIngredient:sender];
              }]];
            [alert addAction:
             [UIAlertAction actionWithTitle:@"ยกเลิก"
                                      style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
              {
                  
                  
              }]];
            
            
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                [alert setModalPresentationStyle:UIModalPresentationPopover];
                
                UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
                CGRect frame = ((UIButton *)sender).bounds;
                frame.origin.y = frame.origin.y-15;
                popPresenter.sourceView = sender;
                popPresenter.sourceRect = frame;
            }
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            [self copyIngredient:sender];
        }
    }
    
}

-(void)copyIngredient:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:colVwMenuWithTakeAway];
    NSIndexPath *tappedIP = [colVwMenuWithTakeAway indexPathForItemAtPoint:buttonPosition];
    NSMutableArray *menuList = _arrOfMenuList[tappedIP.section];
    Menu *menu = menuList[tappedIP.item];
    
    
    NSMutableArray *copyMenuIngredientList = [[NSMutableArray alloc]init];
    NSMutableArray *menuIngredientList = [MenuIngredient getMenuIngredientListWithMenuID:menu.menuID];
    for(MenuIngredient *item in menuIngredientList)
    {
        MenuIngredient *newItem = [item copy];
        newItem.menuIngredientID = [MenuIngredient getNextID];
        newItem.menuID = editMenu.menuID;
        newItem.idInserted = 0;
        newItem.replaceSelf = 0;
        [MenuIngredient addObject:newItem];
        [copyMenuIngredientList addObject:newItem];
    }
    
    [self.homeModel insertItems:dbMenuIngredientList withData:copyMenuIngredientList actionScreen:@"copy menuIngredient in menu screen"];
    flagCopyIngredient = 1;
    
    
    [self performSegueWithIdentifier:@"segUnwindToMenu" sender:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    NSInteger secNum = 0;
    secNum = _selectedMenu?1 + [_arrOfIngredientList count]:0;
    return secNum;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSInteger rowNum = 0;
    if(section == 0)
    {
        rowNum = 4;
    }
    else
    {
        NSMutableArray *ingredientList = _arrOfIngredientList[section-1];
        rowNum = [ingredientList count];
    }
    return rowNum;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierCustomTableViewCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if(section == 0)
    {
        MenuType *menuType = _menuTypeList[_selectedIndexMenuType];
        switch (item) {
            case 0:
            {
                NSString *strPrice = [Utility formatDecimal:_selectedMenu.price];
                cell.lblTextLabel.text = @"ราคา";
                cell.lblDetailTextLabel.text = strPrice;
            }
                break;
            case 1:
            {
                NSString *strAllowDiscount = menuType.allowDiscount?@"ร่วม":@"ไม่ร่วม";
                cell.lblTextLabel.text = @"ร่วมส่วนลด %";
                cell.lblDetailTextLabel.text = strAllowDiscount;
            }
                break;
            case 2:
            {
                cell.lblTextLabel.text = @"หมายเหตุ";
                cell.lblDetailTextLabel.text = _selectedMenu.remark;
            }
                break;
            case 3:
            {
                NSString *strActive = _selectedMenu.status?@"ใช้":@"ไม่ใช้";
                cell.lblTextLabel.text = @"ใช้งานอยู่";
                cell.lblDetailTextLabel.text = strActive;
            }
                break;
            default:
                break;
        }
    }
    else
    {
        NSMutableArray *ingredientList = _arrOfIngredientList[section-1];
        Ingredient *ingredient = ingredientList[item];
        MenuIngredient *menuIngredient = [MenuIngredient getMenuIngredientWithMenuID:_selectedMenu.menuID ingredientID:ingredient.ingredientID];
        NSString *strAmount = [Utility formatDecimal:menuIngredient.amount withMinFraction:2 andMaxFraction:2];
        NSString *strMenuIngredientAmount = [NSString stringWithFormat:@"%@ %@",strAmount,ingredient.uom];
        cell.lblTextLabel.text = ingredient.name;
        cell.lblDetailTextLabel.text = strMenuIngredientAmount;
    }
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view;
    if(section == 0)
    {
        return nil;
    }
    else if(section == 1)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
        
        
        UIFont *font = [UIFont boldSystemFontOfSize:14];
        NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"ส่วนประกอบ"
                                                                                       attributes:attribute];
        
        UILabel *labelIngredientHeader = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, 18)];
        labelIngredientHeader.attributedText = attrString;
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, tableView.frame.size.width, 18)];
        [label setFont:[UIFont boldSystemFontOfSize:14]];
        
        IngredientType *ingredientType = _ingredientTypeList[section-1];
        [label setText:ingredientType.name];
        
        
        [view addSubview:labelIngredientHeader];
        [view addSubview:label];
    }
    else if(section > 1)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, 18)];
        [label setFont:[UIFont boldSystemFontOfSize:14]];
        
        IngredientType *ingredientType = _ingredientTypeList[section-1];
        [label setText:ingredientType.name];
        
        
        [view addSubview:label];
    }
    
    [view setBackgroundColor:[UIColor groupTableViewBackgroundColor]]; //your background color...
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    float headerHeight = 0;
    switch (section) {
        case 0:
            headerHeight = 0;
            break;
        case 1:
            headerHeight = 44;
            break;
        default:
            headerHeight = 18;
            break;
    }
    return headerHeight;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
}

- (IBAction)reorderCell:(id)sender
{
    btnReorder.enabled = NO;
    btnAddEdit.enabled = YES;
    colVwMenuWithTakeAway.collectionViewLayout = [[LXReorderableCollectionViewFlowLayout alloc]init];
    colVwTabMenuType.collectionViewLayout = [[LXReorderableCollectionViewFlowLayout alloc]init];
    [colVwMenuWithTakeAway setContentOffset:CGPointMake(0, 0)];
    
    
    //add action for longPress
    for(int i=0; i<[_menuTypeList count]; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        CustomCollectionViewCellTabMenuType *cell = (CustomCollectionViewCellTabMenuType *)[colVwTabMenuType cellForItemAtIndexPath:indexPath];
        [cell removeGestureRecognizer:cell.longPressGestureRecognizer];
    }
    
    for(int i=0; i<[_arrOfMenuList count]; i++)
    {
        NSMutableArray *menuList = _arrOfMenuList[i];
        for(int j=0; j<[menuList count]; j++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            CustomCollectionViewCellMenuWithTakeAway *cell = (CustomCollectionViewCellMenuWithTakeAway *)[colVwMenuWithTakeAway cellForItemAtIndexPath:indexPath];
            [cell removeGestureRecognizer:cell.longPressGestureRecognizer];
        }
    }
}

- (IBAction)showIngredientSetUp:(id)sender
{
    [self performSegueWithIdentifier:@"segIngredientSetUp" sender:self];
}

- (IBAction)addEditCell:(id)sender
{
//    btnReorder.enabled = YES;
//    btnAddEdit.enabled = NO;
//
//
//    //longpressgesture for add/edit/delete
//    colVwMenuWithTakeAway.collectionViewLayout = [[NDCollectionViewFlowLayout alloc]init];
//    colVwTabMenuType.collectionViewLayout = [[NDCollectionViewFlowLayout alloc]init];
//    [colVwMenuWithTakeAway setContentOffset:CGPointMake(0, 0)];
//
//
//    //add action for longPress
//    for(int i=0; i<[_menuTypeList count]; i++)
//    {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
//        CustomCollectionViewCellTabMenuType *cell = (CustomCollectionViewCellTabMenuType *)[colVwTabMenuType cellForItemAtIndexPath:indexPath];
//        [cell removeGestureRecognizer:cell.longPressGestureRecognizer];
//        [cell.longPressGestureRecognizer addTarget:self action:@selector(handleLongPressTabMenuType:)];
//        [cell addGestureRecognizer:cell.longPressGestureRecognizer];
//    }
//
//    for(int i=0; i<[_arrOfMenuList count]; i++)
//    {
//        NSMutableArray *menuList = _arrOfMenuList[i];
//        for(int j=0; j<[menuList count]; j++)
//        {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
//            CustomCollectionViewCellMenuWithTakeAway *cell = (CustomCollectionViewCellMenuWithTakeAway *)[colVwMenuWithTakeAway cellForItemAtIndexPath:indexPath];
//            [cell removeGestureRecognizer:cell.longPressGestureRecognizer];
//            [cell.longPressGestureRecognizer addTarget:self action:@selector(handleLongPressMenuWithTakeAway:)];
//            [cell addGestureRecognizer:cell.longPressGestureRecognizer];
//        }
//    }
}

- (IBAction)reorderSection:(id)sender
{
//    UIView *headerView;
//    if([_arrOfMenuList count]>0)
//    {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
//        headerView = [colVwMenuWithTakeAway supplementaryViewForElementKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
//
//    }
//    if(!headerView)
//    {
//        return;
//    }
//
//
//
//    // grab the view controller we want to show
//    MenuType *menuType = _menuTypeList[_selectedIndexMenuType];
//    NSMutableArray *subMenuTypeList = [SubMenuType getSubMenuTypeListWithMenuTypeID:menuType.menuTypeID];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    SubMenuTypeReorderViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"SubMenuTypeReorderViewController"];
//    controller.preferredContentSize = CGSizeMake(300, 44*[subMenuTypeList count]+58);
//    controller.vc = self;
//    controller.subMenuTypeList = subMenuTypeList;
//
//
//    // present the controller
//    // on iPad, this will be a Popover
//    // on iPhone, this will be an action sheet
//    controller.modalPresentationStyle = UIModalPresentationPopover;
//    [self presentViewController:controller animated:YES completion:nil];
//
//    // configure the Popover presentation controller
//    UIPopoverPresentationController *popController = [controller popoverPresentationController];
//    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
//
//
//
//    CGRect frame = headerView.frame;
//    frame.origin.y = frame.origin.y-15;
//    popController.sourceView = headerView;
//    popController.sourceRect = frame;
}

- (IBAction)addEditSection:(id)sender//add subMenuType
{
    [self addSubMenuType];
}

- (IBAction)showAll:(id)sender
{
    if([btnShowAll.titleLabel.text isEqualToString:@"แสดงทั้งหมด"])
    {
        [btnShowAll setTitle:@"เฉพาะที่ใช้อยู่" forState:UIControlStateNormal];
        [btnShowAll setSelected:NO];
    }
    else
    {
        [btnShowAll setTitle:@"แสดงทั้งหมด" forState:UIControlStateNormal];
        [btnShowAll setSelected:YES];
    }
    
    [self loadViewProcess];
}

- (IBAction)showAllSubMenu:(id)sender
{
    if([btnShowAllSubMenu.titleLabel.text isEqualToString:@"แสดงทั้งหมด"])
    {
        [btnShowAllSubMenu setTitle:@"เฉพาะที่ใช้อยู่" forState:UIControlStateNormal];
        [btnShowAllSubMenu setSelected:NO];
    }
    else
    {
        [btnShowAllSubMenu setTitle:@"แสดงทั้งหมด" forState:UIControlStateNormal];
        [btnShowAllSubMenu setSelected:YES];
    }
    [self loadViewProcess];
}

-(void)addMenuType:(id)sender
{
    [self addMenuType];
}

-(void)addMenuType
{
//    // grab the view controller we want to show
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    MenuTypeViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"MenuTypeViewController"];
//    controller.preferredContentSize = CGSizeMake(300, 44*3+58);
//    controller.vc = self;
//    controller.editMenuType = nil;
//
//
//
//    // present the controller
//    // on iPad, this will be a Popover
//    // on iPhone, this will be an action sheet
//    controller.modalPresentationStyle = UIModalPresentationPopover;
//    [self presentViewController:controller animated:YES completion:nil];
//
//    // configure the Popover presentation controller
//    UIPopoverPresentationController *popController = [controller popoverPresentationController];
//    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
//
//
//
//    CGRect frame = colVwTabMenuType.frame;
//    frame.origin.y = frame.origin.y-15;
//    popController.sourceView = colVwTabMenuType;
//    popController.sourceRect = frame;
}

-(void)setMenuIngredient
{
    //get ingredient
    _menuIngredientList = [MenuIngredient getMenuIngredientListWithMenuID:_selectedMenu.menuID];
    NSMutableArray *allIngredientList = [[NSMutableArray alloc]init];
    for(MenuIngredient *item in _menuIngredientList)
    {
        Ingredient *ingredient = [Ingredient getIngredient:item.ingredientID];
        [allIngredientList addObject:ingredient];
    }
    
    
    NSSet *ingredientTypeIDSet = [NSSet setWithArray:[allIngredientList valueForKey:@"_ingredientTypeID"]];
    [_ingredientTypeList removeAllObjects];
    for(NSNumber *item in ingredientTypeIDSet)
    {
        IngredientType *ingredientType = [IngredientType getIngredientType:[item integerValue]];
        [_ingredientTypeList addObject:ingredientType];
    }
    
    
    [_arrOfIngredientList removeAllObjects];
    _ingredientTypeList = [IngredientType getIngredientTypeListWithStatus:1 ingredientTypeList:_ingredientTypeList];
    for(IngredientType *item in _ingredientTypeList)
    {
        NSMutableArray *ingredientList = [Ingredient getIngredientListWithIngredientTypeID:item.ingredientTypeID status:1 ingredientList:allIngredientList];
        ingredientList = [Utility sortDataByColumn:ingredientList numOfColumn:2];
        [_arrOfIngredientList addObject:ingredientList];
    }
    
    
    [tbvDetail reloadData];
}

-(void)addMenu:(id)sender
{
//    UIView *button = sender;
//    NSInteger subMenuTypeID = button.tag;
//
//
//    MenuType *menuType = _menuTypeList[_selectedIndexMenuType];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    MenuMasterViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"MenuMasterViewController"];
//    controller.preferredContentSize = CGSizeMake(300, 44*4+58);
//    controller.vc = self;
//    controller.editMenu = nil;
//    controller.editMenuType = menuType;
//    if(subMenuTypeID == -1)
//    {
//        controller.editSubMenuType = nil;
//    }
//    else
//    {
//        controller.editSubMenuType = [SubMenuType getSubMenuType:subMenuTypeID];
//    }
//
//
//    // present the controller
//    // on iPad, this will be a Popover
//    // on iPhone, this will be an action sheet
//    controller.modalPresentationStyle = UIModalPresentationPopover;
//    [self presentViewController:controller animated:YES completion:nil];
//
//    // configure the Popover presentation controller
//    UIPopoverPresentationController *popController = [controller popoverPresentationController];
//    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
//
//
//
//    CGRect frame = colVwMenuWithTakeAway.frame;
//    frame.origin.y = frame.origin.y-15;
//    popController.sourceView = colVwMenuWithTakeAway;
//    popController.sourceRect = frame;
    
}

-(void)addSubMenuType
{
//    // grab the view controller we want to show
//    MenuType *menuType = _menuTypeList[_selectedIndexMenuType];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    SubMenuTypeViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"SubMenuTypeViewController"];
//    controller.preferredContentSize = CGSizeMake(300, 44*2+58);
//    controller.vc = self;
//    controller.editMenuType = menuType;
//    controller.editSubMenuType = nil;
//    
//    
//    // present the controller
//    // on iPad, this will be a Popover
//    // on iPhone, this will be an action sheet
//    controller.modalPresentationStyle = UIModalPresentationPopover;
//    [self presentViewController:controller animated:YES completion:nil];
//    
//    // configure the Popover presentation controller
//    UIPopoverPresentationController *popController = [controller popoverPresentationController];
//    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
//    
//    
//    
//    CGRect frame = colVwMenuWithTakeAway.frame;
//    frame.origin.y = frame.origin.y-15;
//    popController.sourceView = colVwMenuWithTakeAway;
//    popController.sourceRect = frame;
}

- (void)itemsDownloaded:(NSArray *)items
{
    [super itemsDownloaded:items];
    
    if(self.homeModel.propCurrentDB == dbMenuType)
    {
        [MenuType setMenuTypeList:[items[0] mutableCopy]];
        [self removeOverlayViews];
        
        
        [self loadViewProcess];
    }
    else if(self.homeModel.propCurrentDB == dbMenu)
    {
        [Menu setMenuList:[items[0] mutableCopy]];
        [self removeOverlayViews];
        
        
        [self loadViewProcess];
    }
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//    IngredientSetUpViewController *vc = segue.destinationViewController;
//    vc.editMenu = _editMenu;
//    
//}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToMenu" sender:self];
}

@end
