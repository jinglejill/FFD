//
//  IngredientSetUpViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/19/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "IngredientSetUpViewController.h"
#import "CustomCollectionViewCellTabMenuType.h"
#import "CustomCollectionViewCellButton.h"
#import "CustomCollectionViewCellMenuWithTakeAway.h"
#import "CustomCollectionReusableView.h"
#import "CustomTableViewCellLabelLabel.h"
#import "NDCollectionViewFlowLayout.h"

#import "MenuIngredient.h"
#import "IngredientType.h"
#import "SubIngredientType.h"
#import "Ingredient.h"
#import "Utility.h"
#import "IngredientTypeViewController.h"
#import "IngredientViewController.h"
#import "SubIngredientTypeViewController.h"
#import "SubIngredientTypeReorderViewController.h"
#import "IngredientAmountViewController.h"




@interface IngredientSetUpViewController ()
{
    NSMutableArray *_ingredientTypeList;
    NSMutableArray *_subIngredientTypeList;
    NSMutableArray *_arrOfIngredientList;
    NSMutableArray *_emptyIngredientList;
    NSInteger _selectedIndexIngredientType;
    NSInteger _selectedIndexIngredient;
    Ingredient *_selectedIngredient;
    NSIndexPath *_selectedIngredientIP;
    
    
    //for tbv
    NSMutableArray *_menuIngredientList;
    NSMutableArray *_selectedArrOfIngredientList;
    NSMutableArray *_selectedIngredientTypeList;
    
}
@end

@implementation IngredientSetUpViewController
static NSString * const reuseHeaderViewIdentifier = @"CustomCollectionReusableView";
static NSString * const reuseIdentifierTabMenuType = @"CustomCollectionViewCellTabMenuType";
static NSString * const reuseIdentifierButton = @"CustomCollectionViewCellButton";
static NSString * const reuseIdentifierMenuWithTakeAway = @"CustomCollectionViewCellMenuWithTakeAway";
static NSString * const reuseIdentifierLabelLabel = @"CustomTableViewCellLabelLabel";


@synthesize colVwTabIngredientType;
@synthesize colVwIngredient;
@synthesize vwTop;
@synthesize tbvMenuIngredient;
@synthesize btnAddEdit;
@synthesize btnReorder;
@synthesize btnAddEditSubIngredientType;
@synthesize btnReorderSubIngredientType;
@synthesize btnShowAll;
@synthesize btnShowAllSubIngredientType;
@synthesize editMenu;
@synthesize lblMenu;



-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    
    {
        CGRect frame = colVwTabIngredientType.frame;
        
        frame.origin.x = 0;
        frame.origin.y = 20+50;//20 ให้ถัดจาก top status bar
        frame.size.width = ceil(self.view.frame.size.width/3*2)-8-42;//31 แต่ใช้ 42 เลขจะได้หารลงตัวแบ่ง collectionviewcell ได้ไม่มีจุดทศนิยม
        frame.size.height = 91-20-2;//storyboard reference
        colVwTabIngredientType.frame = frame;
//        NSLog(@"colVwTabIngredientType : %f",colVwTabMenuType.frame.size.width);
    }
    
    {
        CGRect frame = colVwIngredient.frame;
        
        frame.origin.x = 0;
        frame.origin.y = 91+8+50;//storyboard reference+gap
        frame.size.width = ceil(self.view.frame.size.width/3*2)-8-42;
        frame.size.height = self.view.frame.size.height-91-8-50;//50 for back button
        colVwIngredient.frame = frame;
    }
    
    {
        CGRect frame = vwTop.frame;
        
        frame.origin.x = colVwTabIngredientType.frame.origin.x + colVwTabIngredientType.frame.size.width + 8;
        frame.origin.y = 20;
        frame.size.width = self.view.frame.size.width - colVwIngredient.frame.size.width - 8;
        frame.size.height = 91-20+50;
        vwTop.frame = frame;
//        NSLog(@"vwTop : (%f,%f,%f,%f)",vwTop.frame.origin.x,vwTop.frame.origin.y, vwTop.frame.size.width,vwTop.frame.size.height);
//        NSLog(@"self.view : (%f,%f,%f,%f)",self.view.frame.origin.x,self.view.frame.origin.y, self.view.frame.size.width,self.view.frame.size.height);
    }
    
    {
        CGRect frame = tbvMenuIngredient.frame;
        
        frame.origin.x = colVwTabIngredientType.frame.origin.x + colVwTabIngredientType.frame.size.width + 8;
        frame.origin.y = 91+8+50;//storyboard reference+gap
        frame.size.width = self.view.frame.size.width - colVwIngredient.frame.size.width - 8;
        frame.size.height = self.view.frame.size.height-91-8-50;
        tbvMenuIngredient.frame = frame;
//        NSLog(@"tbvDetail : %f",tbvDetail.frame.size.width);
    }
    //    NSLog(@"self.view.frame : %f",self.view.frame.size.width);
//    NSLog(@"btn showall : (%f,%f,%f,%f)",btnShowAll.frame.origin.x,btnShowAll.frame.origin.y, btnShowAll.frame.size.width,btnShowAll.frame.size.height);
    
}


- (void)loadView
{
    [super loadView];
    
    _selectedIndexIngredientType = 0;
    _selectedIndexIngredient = -1;
    _arrOfIngredientList = [[NSMutableArray alloc]init];
    _emptyIngredientList = [[NSMutableArray alloc]init];
    _selectedArrOfIngredientList = [[NSMutableArray alloc]init];
    _selectedIngredientTypeList = [[NSMutableArray alloc]init];
    btnAddEdit.enabled = NO;
    colVwIngredient.collectionViewLayout = [[NDCollectionViewFlowLayout alloc]init];
    colVwTabIngredientType.collectionViewLayout = [[NDCollectionViewFlowLayout alloc]init];
    [colVwIngredient setContentOffset:CGPointMake(0, 0)];
    [btnShowAll setTitle:@"แสดงทั้งหมด" forState:UIControlStateNormal];
    [btnShowAllSubIngredientType setTitle:@"แสดงทั้งหมด" forState:UIControlStateNormal];
    [btnShowAll setSelected:YES];
    [btnShowAllSubIngredientType setSelected:YES];
    if(editMenu)
    {
        lblMenu.text = editMenu.titleThai;
        lblMenu.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    else
    {
        lblMenu.text = @"";
        lblMenu.backgroundColor = [UIColor clearColor];
    }
    
    
    
    tbvMenuIngredient.delegate = self;
    tbvMenuIngredient.dataSource = self;
    
    
    //    [self setShadow:colVwTabMenuType];
    [self setShadow:colVwIngredient];
    [self setShadow:tbvMenuIngredient];
    [self loadViewProcess];
}

- (void)loadViewProcess
{
    //menu section
    if(btnShowAll.selected)//เฉพาะที่ใช้อยู่
    {
        _ingredientTypeList = [IngredientType getIngredientTypeListWithStatus:1];
    }
    else
    {
        _ingredientTypeList = [IngredientType getIngredientTypeList];
    }
    if(_selectedIndexIngredientType > [_ingredientTypeList count] - 1)//กรณีลบ menutype
    {
        _selectedIndexIngredientType -= 1;
    }
    [colVwTabIngredientType reloadData];
    
    
    
    if([_ingredientTypeList count]>0)
    {
        [self selectIngredientType];
    }
    else
    {
        [_arrOfIngredientList removeAllObjects];
        [_arrOfIngredientList addObject:_emptyIngredientList];
    }
    btnShowAll.enabled = YES;
    
    
    
    
    
    //ถ้า _selectedIngredient not in _arrOfIngredientList ให้ selectedIngredient = nil
    int doBreak = 0;
    for(NSMutableArray *ingredientList in _arrOfIngredientList)
    {
        for(Ingredient *item in ingredientList)
        {
            if([item isEqual:_selectedIngredient])
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
        _selectedIngredient = nil;
    }
    
    [self setMenuIngredient];
    
    
    
    if([_subIngredientTypeList count] > 0 && [_ingredientTypeList count] > 0)
    {
        btnAddEditSubIngredientType.enabled = YES;
    }
    else
    {
        btnAddEditSubIngredientType.enabled = NO;
    }
}

- (void)selectIngredientType
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedIndexIngredientType inSection:0];
    [colVwTabIngredientType selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    
    
    
    [_arrOfIngredientList removeAllObjects];
    _selectedIndexIngredientType = _selectedIndexIngredientType>=[_ingredientTypeList count]?[_ingredientTypeList count]-1:_selectedIndexIngredientType;
    IngredientType *ingredientType = _ingredientTypeList[_selectedIndexIngredientType];
    if(btnShowAllSubIngredientType.selected)
    {
        _subIngredientTypeList = [SubIngredientType getSubIngredientTypeListWithIngredientTypeID:ingredientType.ingredientTypeID status:1];
    }
    else
    {
        _subIngredientTypeList = [SubIngredientType getSubIngredientTypeListWithIngredientTypeID:ingredientType.ingredientTypeID];
    }
    if([_subIngredientTypeList count] == 0)
    {
        [_arrOfIngredientList addObject:_emptyIngredientList];
    }
    else
    {
        btnShowAll.enabled = YES;
        
        for(SubIngredientType *item in _subIngredientTypeList)
        {
            if(btnShowAll.selected)//เฉพาะที่ใช้งาน
            {
                NSMutableArray *ingredientList = [Ingredient getIngredientListWithIngredientTypeID:ingredientType.ingredientTypeID subIngredientTypeID:item.subIngredientTypeID status:1];
                ingredientList = [Utility sortDataByColumn:ingredientList numOfColumn:2];
                [_arrOfIngredientList addObject:ingredientList];
            }
            else
            {
                NSMutableArray *ingredientList = [Ingredient getIngredientListWithIngredientTypeID:ingredientType.ingredientTypeID subIngredientTypeID:item.subIngredientTypeID];
                ingredientList = [Utility sortDataByColumn:ingredientList numOfColumn:2];
                [_arrOfIngredientList addObject:ingredientList];
            }
        }
    }
    
    
    [colVwIngredient reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectIngredientType)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    
    
    // Do any additional setup after loading the view.
    colVwTabIngredientType.delegate = self;
    colVwTabIngredientType.dataSource = self;
    colVwIngredient.delegate = self;
    colVwIngredient.dataSource = self;
    
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierTabMenuType bundle:nil];
        [colVwTabIngredientType registerNib:nib forCellWithReuseIdentifier:reuseIdentifierTabMenuType];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierButton bundle:nil];
        [colVwTabIngredientType registerNib:nib forCellWithReuseIdentifier:reuseIdentifierButton];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierMenuWithTakeAway bundle:nil];
        [colVwIngredient registerNib:nib forCellWithReuseIdentifier:reuseIdentifierMenuWithTakeAway];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierButton bundle:nil];
        [colVwIngredient registerNib:nib forCellWithReuseIdentifier:reuseIdentifierButton];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseHeaderViewIdentifier bundle:nil];
        [colVwIngredient registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderViewIdentifier];
    }
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelLabel bundle:nil];
        [tbvMenuIngredient registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelLabel];
    }
    
    
    
    if([_ingredientTypeList count]>0)
    {
        [self selectIngredientType];
    }
    
    
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture setCancelsTouchesInView:NO];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger numberOfSection = 1;
    if([collectionView isEqual:colVwTabIngredientType])
    {
        numberOfSection = 1;
    }
    else if([collectionView isEqual:colVwIngredient])
    {
        if([_subIngredientTypeList count] == 0 && [_ingredientTypeList count] > 0)
        {
            numberOfSection = 1;
        }
        else
        {
            numberOfSection = [_subIngredientTypeList count];
        }
    }
    
    return  numberOfSection;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if([collectionView isEqual:colVwTabIngredientType])
    {
        if([_ingredientTypeList count] == 0)
        {
            return 1;
        }
        else
        {
            return [_ingredientTypeList count];
        }
    }
    else if([collectionView isEqual:colVwIngredient])
    {
        //load menu มาโชว์
        NSMutableArray *ingredientList = _arrOfIngredientList[section];
        if([ingredientList count] == 0)
        {
            return 1;
        }
        else
        {
            return [ingredientList count];
        }
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSInteger item = indexPath.item;
    NSInteger section = indexPath.section;
    
    
    if([collectionView isEqual:colVwTabIngredientType])
    {
        if([_ingredientTypeList count] == 0)
        {
            CustomCollectionViewCellButton *cell = (CustomCollectionViewCellButton *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierButton forIndexPath:indexPath];
            cell.contentView.userInteractionEnabled = NO;
            
            
            [cell.btnValue setTitle:@"เพิ่มหมวดส่วนประกอบ" forState:UIControlStateNormal];
            [cell.btnValue addTarget:self action:@selector(addIngredientType:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnWidthConstant.constant = cell.frame.size.width-16;
            
     
            return cell;
        }
        else
        {
            CustomCollectionViewCellTabMenuType *cell = (CustomCollectionViewCellTabMenuType *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierTabMenuType forIndexPath:indexPath];
            
            
            IngredientType *ingredientType = _ingredientTypeList[item];
            cell.lblMenuType.text = ingredientType.name;
            if(item == _selectedIndexIngredientType)
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
            
            
            [cell removeGestureRecognizer:cell.longPressGestureRecognizer];
            if([colVwTabIngredientType.collectionViewLayout isMemberOfClass:[NDCollectionViewFlowLayout class]])
            {
                [cell.longPressGestureRecognizer addTarget:self action:@selector(handleLongPressTabIngredientType:)];
                [cell addGestureRecognizer:cell.longPressGestureRecognizer];
            }
            
            
            return cell;
        }
    }
    else if([collectionView isEqual:colVwIngredient])
    {
        NSMutableArray *ingredientList = _arrOfIngredientList[section];
        NSInteger subIngredientTypeID = -1;
        if([_subIngredientTypeList count] > 0)
        {
            SubIngredientType *subIngredientType = _subIngredientTypeList[section];
            subIngredientTypeID = subIngredientType.subIngredientTypeID;
        }
        
        
        if([ingredientList count] == 0)
        {
            CustomCollectionViewCellButton *cell = (CustomCollectionViewCellButton *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierButton forIndexPath:indexPath];
            cell.contentView.userInteractionEnabled = NO;
            
            
            [cell.btnValue setTitle:@"เพิ่มชื่อส่วนประกอบ" forState:UIControlStateNormal];
            [cell.btnValue addTarget:self action:@selector(addIngredient:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnValue.tag = subIngredientTypeID;
            cell.btnWidthConstant.constant = cell.frame.size.width-16;
            
            
            return cell;
        }
        else
        {
            CustomCollectionViewCellMenuWithTakeAway *cell = (CustomCollectionViewCellMenuWithTakeAway*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierMenuWithTakeAway forIndexPath:indexPath];
            
            
            
            cell.contentView.userInteractionEnabled = NO;
            NSMutableArray *ingredientList = _arrOfIngredientList[section];
            Ingredient *ingredient = ingredientList[item];
            
            
            //tap menu
            cell.btnMenuName.tag = item;
            [cell.btnMenuName setTitle:ingredient.name forState:UIControlStateNormal];
            [cell.btnMenuName addTarget:self action:@selector(addMenuIngredientTouchDown:) forControlEvents:UIControlEventTouchDown];
            [cell.btnMenuName addTarget:self action:@selector(addMenuIngredient:) forControlEvents:UIControlEventTouchUpInside];
            
            
            cell.btnTakeAway.hidden = YES;
            if(indexPath == _selectedIngredientIP)
            {
                cell.backgroundColor = mLightBlueColor;
                cell.vwRoundedCorner.backgroundColor = mLightBlueColor;
            }
            else
            {
                cell.backgroundColor = [UIColor clearColor];
                cell.vwRoundedCorner.backgroundColor = [UIColor clearColor];
            }
            
            
            [cell removeGestureRecognizer:cell.longPressGestureRecognizer];
            if([colVwIngredient.collectionViewLayout isMemberOfClass:[NDCollectionViewFlowLayout class]])
            {
                [cell.longPressGestureRecognizer addTarget:self action:@selector(handleLongPressIngredient:)];
                [cell addGestureRecognizer:cell.longPressGestureRecognizer];
            }
            
            
            return cell;
        }
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([collectionView isEqual:colVwTabIngredientType])
    {
        if([_ingredientTypeList count] > 0)
        {
            _selectedIndexIngredientType = indexPath.item;
            
            
            _selectedIngredient = nil;
            _selectedIndexIngredient = -1;
            _selectedIngredientIP = nil;
            [tbvMenuIngredient reloadData];
            
            
            
            CustomCollectionViewCellTabMenuType * cell = (CustomCollectionViewCellTabMenuType *)[collectionView cellForItemAtIndexPath:indexPath];
            cell.vwBottomBorder.hidden = YES;
            cell.lblMenuType.font = [UIFont boldSystemFontOfSize:15.0f];
            cell.lblMenuType.textColor = mBlueColor;
            cell.backgroundColor = mLightBlueColor;
            
            
            [self selectIngredientType];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([collectionView isEqual:colVwTabIngredientType])
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
    
    if([collectionView isEqual:colVwTabIngredientType])
    {
        if([_ingredientTypeList count] == 0)
        {
            size = CGSizeMake(colVwTabIngredientType.frame.size.width,colVwTabIngredientType.frame.size.height/2);
        }
        else
        {
            float row = 2;
            NSInteger column = ceil([_ingredientTypeList count]/row);
            size = CGSizeMake(colVwTabIngredientType.frame.size.width/column,colVwTabIngredientType.frame.size.height/row);
        }
    }
    else if([collectionView isEqual:colVwIngredient])
    {
        //load menu มาโชว์
        NSMutableArray *ingredientList = _arrOfIngredientList[indexPath.section];
        if([ingredientList count] == 0)
        {
            size = CGSizeMake(colVwIngredient.frame.size.width,44);
        }
        else
        {
            size = CGSizeMake(colVwIngredient.frame.size.width/2,44);
        }
    }
    
    
    return size;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    {
        NDCollectionViewFlowLayout *layout = (NDCollectionViewFlowLayout *)colVwTabIngredientType.collectionViewLayout;
        
        [layout invalidateLayout];
        [colVwTabIngredientType reloadData];
    }
    {
        NDCollectionViewFlowLayout *layout = (NDCollectionViewFlowLayout *)colVwIngredient.collectionViewLayout;
        
        [layout invalidateLayout];
        [colVwIngredient reloadData];
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
    
    
    if([collectionView isEqual:colVwIngredient])
    {
        if (kind == UICollectionElementKindSectionHeader)
        {
            CustomCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderViewIdentifier forIndexPath:indexPath];
            
            [self setShadow:headerView];
            headerView.tag = section;
            [headerView removeGestureRecognizer:headerView.longPressGestureRecognizer];
            [headerView.longPressGestureRecognizer addTarget:self action:@selector(handleLongPressSubIngredientType:)];
            [headerView addGestureRecognizer:headerView.longPressGestureRecognizer];
            
            if(section == 0)
            {
                if([_arrOfIngredientList count] > 1)
                {
                    SubIngredientType *subIngredientType = _subIngredientTypeList[section];
                    headerView.lblHeaderName.text = subIngredientType.name;
                }
            }
            else
            {
                SubIngredientType *subIngredientType = _subIngredientTypeList[section];
                headerView.lblHeaderName.text = subIngredientType.name;
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
    if([collectionView isEqual:colVwIngredient])
    {
        if(section == 0)
        {
            if([_arrOfIngredientList count] > 1)
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
    
    if([collectionView isEqual:colVwIngredient])
    {
        NSMutableArray *ingredientList = _arrOfIngredientList[fromIndexPath.section];
        Ingredient *ingredient = ingredientList[fromIndexPath.item];
        [ingredientList removeObjectAtIndex:fromIndexPath.item];
        
        
        
        NSMutableArray *ingredientList2 = _arrOfIngredientList[toIndexPath.section];
        [ingredientList2 insertObject:ingredient atIndex:toIndexPath.item];
        SubIngredientType *subIngredientType2 = _subIngredientTypeList[toIndexPath.section];
        
        
        
        //check idinserted
        {
            for(Ingredient *item in ingredientList2)
            {
                if(!item.idInserted)
                {
                    [self showAlertAndCallPushSync:@"" message:@"ไม่สามารถจัดลำดับส่วนประกอบได้ กรุณาลองใหม่อีกครั้ง"];
                    [self loadingOverlayView];
                    self.homeModel = [[HomeModel alloc]init];
                    self.homeModel.delegate = self;
                    [self.homeModel downloadItems:dbIngredient];
                    return;
                }
            }
        }
        
        
        int i=0;
        for(Ingredient *item in ingredientList2)
        {
            item.orderNo = i;
            item.subIngredientTypeID = subIngredientType2.subIngredientTypeID;
            item.modifiedUser = [Utility modifiedUser];
            item.modifiedDate = [Utility currentDateTime];
            i++;
        }
        [self.homeModel updateItems:dbIngredientList withData:ingredientList2 actionScreen:@"reorder ingredient in ingredient setup screen"];
    }
    else if([collectionView isEqual:colVwTabIngredientType])
    {
        IngredientType *ingredientType = _ingredientTypeList[fromIndexPath.item];
        [_ingredientTypeList removeObjectAtIndex:fromIndexPath.item];
        [_ingredientTypeList insertObject:ingredientType atIndex:toIndexPath.item];
        
        //check idinserted
        {
            for(IngredientType *item in _ingredientTypeList)
            {
                if(!item.idInserted)
                {
                    [self showAlertAndCallPushSync:@"" message:@"ไม่สามารถจัดลำดับหมวดส่วนประกอบได้ กรุณาลองใหม่อีกครั้ง"];
                    [self loadingOverlayView];
                    self.homeModel = [[HomeModel alloc]init];
                    self.homeModel.delegate = self;
                    [self.homeModel downloadItems:dbIngredientType];
                    return;
                }
            }
        }
        
        
        
        int i=0;
        for(IngredientType *item in _ingredientTypeList)
        {
            item.orderNo = i;
            item.modifiedUser = [Utility modifiedUser];
            item.modifiedDate = [Utility currentDateTime];
            i++;
        }
        [self.homeModel updateItems:dbIngredientTypeList withData:_ingredientTypeList actionScreen:@"reorder IngredientType in Ingredient setUp screen"];
    }
}

- (void)addMenuIngredientTouchDown:(id)sender
{
    UIButton *button = sender;
    [button setTitleColor:mBlueColor forState:UIControlStateNormal];
    double delayInSeconds = 0.3;//delay 1.3 เพราะไม่อยากให้กดเบิ้ล(กด insert และ update ด้วยปุ่มเดิม) หน่วงเพื่อหลอกตา แต่ว่ามีเช็ค idinserted เผื่อไว้อยู่แล้ว จะใช้ 0.3 กรณีที่ไม่ได้ต้องกดต่อเนื่อง คือ insert แล้ว update หรือ delete โดยใช้ปุ่มเดิม
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    });
}

- (void)addMenuIngredient:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:colVwIngredient];
    NSIndexPath *tappedIP = [colVwIngredient indexPathForItemAtPoint:buttonPosition];
    NSMutableArray *ingredientList = _arrOfIngredientList[tappedIP.section];
    Ingredient *ingredient = ingredientList[tappedIP.item];
    
    
    //highlight selected
    if(_selectedIngredientIP)
    {
        CustomCollectionViewCellMenuWithTakeAway *cell = (CustomCollectionViewCellMenuWithTakeAway *)[colVwIngredient cellForItemAtIndexPath:_selectedIngredientIP];
        cell.backgroundColor = [UIColor clearColor];
        cell.vwRoundedCorner.backgroundColor = [UIColor clearColor];
    }
    
    
    {
        _selectedIngredientIP = tappedIP;
        CustomCollectionViewCellMenuWithTakeAway *cell = (CustomCollectionViewCellMenuWithTakeAway *)[colVwIngredient cellForItemAtIndexPath:_selectedIngredientIP];
        cell.backgroundColor = mLightBlueColor;
        cell.vwRoundedCorner.backgroundColor = mLightBlueColor;
    }
    
    
    
    //เช็คว่า menu นี้มี ingredient นี้ รึเปล่า
    MenuIngredient *menuIngredient = [MenuIngredient getMenuIngredientWithMenuID:editMenu.menuID ingredientID:ingredient.ingredientID];
    if(!menuIngredient)
    {
        menuIngredient = [[MenuIngredient alloc]initWithMenuID:editMenu.menuID ingredientID:ingredient.ingredientID amount:0];
        [MenuIngredient addObject:menuIngredient];
        [self.homeModel insertItems:dbMenuIngredient withData:menuIngredient actionScreen:@"insert menuIngredient in ingredientSetUp screen"];
        [self setMenuIngredient];
    }
}

- (void)handleLongPressTabIngredientType:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:colVwTabIngredientType];
    NSIndexPath * tappedIP = [colVwTabIngredientType indexPathForItemAtPoint:point];
    UICollectionViewCell *cell = [colVwTabIngredientType cellForItemAtIndexPath:tappedIP];
    
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:
     [UIAlertAction actionWithTitle:@"เพิ่ม"
                              style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
      {
          [self addIngredientType];
      }]];
    [alert addAction:
     [UIAlertAction actionWithTitle:@"แก้ไข"
                              style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
      {
          // grab the view controller we want to show
          UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
          IngredientTypeViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"IngredientTypeViewController"];
          controller.preferredContentSize = CGSizeMake(300, 44*2+58+60);
          controller.vc = self;
          controller.editIngredientType = _ingredientTypeList[tappedIP.item];
          
          
          
          // present the controller
          // on iPad, this will be a Popover
          // on iPhone, this will be an action sheet
          controller.modalPresentationStyle = UIModalPresentationPopover;
          [self presentViewController:controller animated:YES completion:nil];
          
          // configure the Popover presentation controller
          UIPopoverPresentationController *popController = [controller popoverPresentationController];
          popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
          popController.delegate = self;
          
          
          CGRect frame = cell.bounds;
          frame.origin.y = frame.origin.y-15;
          popController.sourceView = cell;
          popController.sourceRect = frame;
          
      }]];
    [alert addAction:
     [UIAlertAction actionWithTitle:@"ลบ"
                              style:UIAlertActionStyleDestructive
                            handler:^(UIAlertAction *action)
      {
          //ลบไม่ได้ถ้ามี submenu ภายใต้
          IngredientType *ingredientType = _ingredientTypeList[tappedIP.item];
          NSMutableArray *subIngredientList = [SubIngredientType getSubIngredientTypeListWithIngredientTypeID:ingredientType.ingredientTypeID];
          if([subIngredientList count]>0)
          {
              [self showAlert:@"" message:@"ไม่สามารถลบได้ มีหมวดหมู่ย่อยภายใต้หมวดส่วนประกอบนี้"];
              return;
          }
          else
          {
              if(!ingredientType.idInserted)
              {
                  [self showAlertAndCallPushSync:@"" message:@"ไม่สามารถลบหมวดส่วนประกอบได้ กรุณาลองใหม่อีกครั้ง"];
                  return;
              }
              [IngredientType removeObject:ingredientType];
              [self.homeModel deleteItems:dbIngredientType withData:ingredientType actionScreen:@"delete ingredientType in ingredientSetUp screen"];
              
              
              [self loadViewProcess];
          }
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

- (void)handleLongPressIngredient:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:colVwIngredient];
    NSIndexPath * tappedIP = [colVwIngredient indexPathForItemAtPoint:point];
    UICollectionViewCell *cell = [colVwIngredient cellForItemAtIndexPath:tappedIP];
    
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:
     [UIAlertAction actionWithTitle:@"เพิ่ม"
                              style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
      {
          // grab the view controller we want to show
          IngredientType *ingredientType = _ingredientTypeList[_selectedIndexIngredientType];
          SubIngredientType *subIngredientType = _subIngredientTypeList[tappedIP.section];
          UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
          IngredientViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"IngredientViewController"];
          controller.preferredContentSize = CGSizeMake(300, 44*5+58);
          controller.vc = self;
          controller.editIngredient = nil;
          controller.editIngredientType = ingredientType;
          controller.editSubIngredientType = subIngredientType;
          
          
          // present the controller
          // on iPad, this will be a Popover
          // on iPhone, this will be an action sheet
          controller.modalPresentationStyle = UIModalPresentationPopover;
          [self presentViewController:controller animated:YES completion:nil];
          
          // configure the Popover presentation controller
          UIPopoverPresentationController *popController = [controller popoverPresentationController];
          popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
          popController.delegate = self;
          
          
          CGRect frame = colVwIngredient.frame;
          frame.origin.y = frame.origin.y-15;
          popController.sourceView = colVwIngredient;
          popController.sourceRect = frame;
      }]];
    [alert addAction:
     [UIAlertAction actionWithTitle:@"แก้ไข"
                              style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
      {
          // grab the view controller we want to show
          IngredientType *ingredientType = _ingredientTypeList[_selectedIndexIngredientType];
          SubIngredientType *subIngredientType = _subIngredientTypeList[tappedIP.section];
          NSMutableArray *ingredientList = _arrOfIngredientList[tappedIP.section];
          Ingredient *ingredient = ingredientList[tappedIP.item];
          UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
          IngredientViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"IngredientViewController"];
          controller.preferredContentSize = CGSizeMake(300, 44*5+58);
          controller.vc = self;
          controller.editIngredient = ingredient;
          controller.editIngredientType = ingredientType;
          controller.editSubIngredientType = subIngredientType;
          
          
          
          // present the controller
          // on iPad, this will be a Popover
          // on iPhone, this will be an action sheet
          controller.modalPresentationStyle = UIModalPresentationPopover;
          [self presentViewController:controller animated:YES completion:nil];
          
          // configure the Popover presentation controller
          UIPopoverPresentationController *popController = [controller popoverPresentationController];
          popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
          popController.delegate = self;
          
          
          CGRect frame = cell.bounds;
          frame.origin.y = frame.origin.y-15;
          popController.sourceView = cell;
          popController.sourceRect = frame;
      }]];
    [alert addAction:
     [UIAlertAction actionWithTitle:@"ลบ"
                              style:UIAlertActionStyleDestructive
                            handler:^(UIAlertAction *action) {
                                
                                //ลบไม่ได้ถ้ามี menuIngredient ภายใต้
                                NSMutableArray *ingredientList = _arrOfIngredientList[tappedIP.section];
                                Ingredient *ingredient = ingredientList[tappedIP.item];
                                
                                NSMutableArray *menuIngredientList = [MenuIngredient getMenuIngredientListWithIngredientID:ingredient.ingredientID];
                                if([menuIngredientList count]>0)
                                {
                                    [self showAlert:@"" message:@"ไม่สามารถลบได้ มีเมนูอาหารใช้ส่วนประกอบนี้อยู่"];
                                    return;
                                }
                                else
                                {
                                    //check idinserted
                                    {
                                        IngredientType *ingredientType = _ingredientTypeList[_selectedIndexIngredientType];
                                        NSMutableArray *allIngredientList = [Ingredient getIngredientListWithIngredientTypeID:ingredientType.ingredientTypeID];
                                        if([allIngredientList count] == 1)
                                        {
                                            SubIngredientType *subIngredientType = [SubIngredientType getSubIngredientType:ingredient.subIngredientTypeID];
                                            if(!subIngredientType.idInserted)
                                            {
                                                [self showAlertAndCallPushSync:@"" message:@"ไม่สามารถลบชื่อส่วนประกอบได้ กรุณาลองใหม่อีกครั้ง"];
                                                return;
                                            }
                                        }
                                        
                                        
                                        
                                        if(!ingredient.idInserted)
                                        {
                                            [self showAlertAndCallPushSync:@"" message:@"ไม่สามารถลบชื่อส่วนประกอบได้ กรุณาลองใหม่อีกครั้ง"];
                                            return;
                                        }
                                    }
                                    
                                    
                                    
                                    
                                    //ถ้ามี 1 ingredient ใน ingredienttypeid นี้ ให้ลบ subingredientType ออกไปด้วยเลย
                                    IngredientType *ingredientType = _ingredientTypeList[_selectedIndexIngredientType];
                                    NSMutableArray *allIngredientList = [Ingredient getIngredientListWithIngredientTypeID:ingredientType.ingredientTypeID];
                                    if([allIngredientList count] == 1)
                                    {
                                        SubIngredientType *subIngredientType = [SubIngredientType getSubIngredientType:ingredient.subIngredientTypeID];
                                        [SubIngredientType removeObject:subIngredientType];
                                        [self.homeModel deleteItems:dbSubIngredientType withData:subIngredientType actionScreen:@"delete subIngredientType when delete last ingredient of any ingredientType in ingredient screen"];
                                    }
                                    
                                    [Ingredient removeObject:ingredient];
                                    [self.homeModel deleteItems:dbIngredient withData:ingredient actionScreen:@"delete ingredient in ingredient screen"];
                                    [_arrOfIngredientList[tappedIP.section] removeObject:ingredient];
                                    
                                    
                                    
                                    if(![_arrOfIngredientList[tappedIP.section] containsObject:_selectedIngredient])
                                    {
                                        _selectedIngredient = nil;
                                    }
                                    
                                    
                                    [self loadViewProcess];
                                }
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

- (void)handleLongPressSubIngredientType:(UILongPressGestureRecognizer *)gestureRecognizer
{

    UIView *headerView = gestureRecognizer.view;
    NSInteger section = headerView.tag;
    
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:
     [UIAlertAction actionWithTitle:@"เพิ่ม"
                              style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
      {
          [self addSubIngredientType];
          
      }]];
    [alert addAction:
     [UIAlertAction actionWithTitle:@"แก้ไข"
                              style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
      {
          // grab the view controller we want to show
          IngredientType *ingredientType = _ingredientTypeList[_selectedIndexIngredientType];
          SubIngredientType *subIngredientType = _subIngredientTypeList[section];
          UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
          SubIngredientTypeViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"SubIngredientTypeViewController"];
          controller.preferredContentSize = CGSizeMake(300, 44*2+58+60);
          controller.vc = self;
          controller.editIngredientType = ingredientType;
          controller.editSubIngredientType = subIngredientType;
          
          
          // present the controller
          // on iPad, this will be a Popover
          // on iPhone, this will be an action sheet
          controller.modalPresentationStyle = UIModalPresentationPopover;
          [self presentViewController:controller animated:YES completion:nil];
          
          // configure the Popover presentation controller
          UIPopoverPresentationController *popController = [controller popoverPresentationController];
          popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
          popController.delegate = self;
          
          
          CGRect frame = headerView.bounds;
          frame.origin.y = frame.origin.y-15;
          popController.sourceView = headerView;
          popController.sourceRect = frame;
      }]];
    [alert addAction:
     [UIAlertAction actionWithTitle:@"ลบ"
                              style:UIAlertActionStyleDestructive
                            handler:^(UIAlertAction *action) {
                                
                                //ลบไม่ได้ถ้ามี menu ภายใต้
                                NSMutableArray *ingredientList = _arrOfIngredientList[section];
                                SubIngredientType *subIngredientType = _subIngredientTypeList[section];
                                if([ingredientList count]>0)
                                {
                                    [self showAlert:@"" message:@"ไม่สามารถลบได้ มีชื่อส่วนประกอบภายใต้หมวดหมู่ย่อยนี้"];
                                    return;
                                }
                                else
                                {
                                    if(!subIngredientType.idInserted)
                                    {
                                        [self showAlertAndCallPushSync:@"" message:@"ไม่สามารถลบหมวดหมู่ย่อยได้ กรุณาลองใหม่อีกครั้ง"];
                                        return;
                                    }
                                    [SubIngredientType removeObject:subIngredientType];
                                    [self.homeModel deleteItems:dbSubIngredientType withData:subIngredientType actionScreen:@"delete subIngredientType in menu screen"];
                                    
                                    
                                    [self loadViewProcess];
                                }
                            }]];
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        [alert setModalPresentationStyle:UIModalPresentationPopover];
        
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        CGRect frame = headerView.bounds;
        frame.origin.y = frame.origin.y-15;
        popPresenter.sourceView = headerView;
        popPresenter.sourceRect = frame;
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)handleLongPressMenuIngredient:(UILongPressGestureRecognizer *)gestureRecognizer
{
    
    CGPoint point = [gestureRecognizer locationInView:tbvMenuIngredient];
    NSIndexPath * tappedIP = [tbvMenuIngredient indexPathForRowAtPoint:point];
    UITableViewCell *cell = [tbvMenuIngredient cellForRowAtIndexPath:tappedIP];
    
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:
     [UIAlertAction actionWithTitle:@"แก้ไข"
                              style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
      {
          // grab the view controller we want to show

          NSMutableArray *ingredientList = _selectedArrOfIngredientList[tappedIP.section];
          Ingredient *ingredient = ingredientList[tappedIP.item];
          MenuIngredient *menuIngredient = [MenuIngredient getMenuIngredientWithMenuID:editMenu.menuID ingredientID:ingredient.ingredientID];
          UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
          IngredientAmountViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"IngredientAmountViewController"];
          controller.preferredContentSize = CGSizeMake(300, 44*2+58+60);
          controller.vc = self;
          controller.editMenuIngredient = menuIngredient;
          
          
          
          
          // present the controller
          // on iPad, this will be a Popover
          // on iPhone, this will be an action sheet
          controller.modalPresentationStyle = UIModalPresentationPopover;
          [self presentViewController:controller animated:YES completion:nil];
          
          // configure the Popover presentation controller
          UIPopoverPresentationController *popController = [controller popoverPresentationController];
          popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
          popController.delegate = self;
          
          
          CGRect frame = cell.bounds;
          frame.origin.y = frame.origin.y-15;
          popController.sourceView = cell;
          popController.sourceRect = frame;
      }]];
    [alert addAction:
     [UIAlertAction actionWithTitle:@"ลบ"
                              style:UIAlertActionStyleDestructive
                            handler:^(UIAlertAction *action) {
                                
                                
                                {
                                    //check idinserted
                                    {
                                        NSMutableArray *ingredientList = _selectedArrOfIngredientList[tappedIP.section];
                                        Ingredient *ingredient = ingredientList[tappedIP.item];
                                        MenuIngredient *menuIngredient = [MenuIngredient getMenuIngredientWithMenuID:editMenu.menuID ingredientID:ingredient.ingredientID];
                                        if(!menuIngredient.idInserted)
                                        {
                                            [self showAlertAndCallPushSync:@"" message:@"ไม่สามารถลบส่วนประกอบของเมนูนี้ได้ กรุณาลองใหม่อีกครั้ง"];
                                            return;

                                        }
                                    }
//
                                    
                                    
                                    
            
                                    NSMutableArray *ingredientList = _selectedArrOfIngredientList[tappedIP.section];
                                    Ingredient *ingredient = ingredientList[tappedIP.item];
                                    MenuIngredient *menuIngredient = [MenuIngredient getMenuIngredientWithMenuID:editMenu.menuID ingredientID:ingredient.ingredientID];
                                    [MenuIngredient removeObject:menuIngredient];
                                    [self.homeModel deleteItems:dbMenuIngredient withData:menuIngredient actionScreen:@"delete menuIngredient in ingredientSetUp screen"];
                                    
                                    
                                    
                                    
                                    
                                    [self loadViewProcess];
                                }
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    NSInteger secNum = 0;
    
    secNum = editMenu?[_selectedArrOfIngredientList count]:0;
    
    return secNum;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSInteger rowNum = 0;
    NSMutableArray *ingredientList = _selectedArrOfIngredientList[section];
    rowNum = [ingredientList count];
    return rowNum;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    CustomTableViewCellLabelLabel *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelLabel forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    

    NSMutableArray *ingredientList = _selectedArrOfIngredientList[section];
    Ingredient *ingredient = ingredientList[item];
    MenuIngredient *menuIngredient = [MenuIngredient getMenuIngredientWithMenuID:editMenu.menuID ingredientID:ingredient.ingredientID];
    NSString *strAmount = [Utility formatDecimal:menuIngredient.amount withMinFraction:0 andMaxFraction:4];
    NSString *strMenuIngredientAmount = [NSString stringWithFormat:@"%@ %@",strAmount,ingredient.uom];
    cell.lblTextLabel.text = ingredient.name;
    cell.lblDetailTextLabel.text = strMenuIngredientAmount;
    
    
    if(ingredient.status)
    {
        cell.lblTextLabel.textColor = [UIColor blackColor];
        cell.lblDetailTextLabel.textColor = [UIColor blackColor];
    }
    else
    {
        cell.lblTextLabel.textColor = [UIColor grayColor];
        cell.lblDetailTextLabel.textColor = [UIColor grayColor];
    }
    
    
    [cell removeGestureRecognizer:cell.longPressGestureRecognizer];
    [cell.longPressGestureRecognizer addTarget:self action:@selector(handleLongPressMenuIngredient:)];
    [cell addGestureRecognizer:cell.longPressGestureRecognizer];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view;

    if(section == 0)
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
        
        IngredientType *ingredientType = _selectedIngredientTypeList[section];
        [label setText:ingredientType.name];
        if(ingredientType.status)
        {
            label.textColor = [UIColor blackColor];
        }
        else
        {
            label.textColor = [UIColor grayColor];
        }
        
        
        [view addSubview:labelIngredientHeader];
        [view addSubview:label];
    }
    else if(section > 0)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, 18)];
        [label setFont:[UIFont boldSystemFontOfSize:14]];
        
        IngredientType *ingredientType = _selectedIngredientTypeList[section];
        [label setText:ingredientType.name];
        if(ingredientType.status)
        {
            label.textColor = [UIColor blackColor];
        }
        else
        {
            label.textColor = [UIColor grayColor];
        }
        
        
        [view addSubview:label];
    }
    
    [view setBackgroundColor:[UIColor groupTableViewBackgroundColor]]; //your background color...
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    float headerHeight = 0;
    switch (section) {
        case 0:
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

- (IBAction)reorderCell:(id)sender
{
    btnReorder.enabled = NO;
    btnAddEdit.enabled = YES;
    colVwIngredient.collectionViewLayout = [[LXReorderableCollectionViewFlowLayout alloc]init];
    colVwTabIngredientType.collectionViewLayout = [[LXReorderableCollectionViewFlowLayout alloc]init];
    [colVwIngredient setContentOffset:CGPointMake(0, 0)];
    
    
    //add action for longPress
    for(int i=0; i<[_ingredientTypeList count]; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        CustomCollectionViewCellTabMenuType *cell = (CustomCollectionViewCellTabMenuType *)[colVwTabIngredientType cellForItemAtIndexPath:indexPath];
        [cell removeGestureRecognizer:cell.longPressGestureRecognizer];
    }
    
    for(int i=0; i<[_arrOfIngredientList count]; i++)
    {
        NSMutableArray *ingredientList = _arrOfIngredientList[i];
        for(int j=0; j<[ingredientList count]; j++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            CustomCollectionViewCellMenuWithTakeAway *cell = (CustomCollectionViewCellMenuWithTakeAway *)[colVwIngredient cellForItemAtIndexPath:indexPath];
            [cell removeGestureRecognizer:cell.longPressGestureRecognizer];
        }
    }
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToMenu" sender:self];
}

- (IBAction)addEditCell:(id)sender
{
    btnReorder.enabled = YES;
    btnAddEdit.enabled = NO;
    
    
    //longpressgesture for add/edit/delete
    colVwIngredient.collectionViewLayout = [[NDCollectionViewFlowLayout alloc]init];
    colVwTabIngredientType.collectionViewLayout = [[NDCollectionViewFlowLayout alloc]init];
    [colVwIngredient setContentOffset:CGPointMake(0, 0)];
    
    
    //add action for longPress
    for(int i=0; i<[_ingredientTypeList count]; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        CustomCollectionViewCellTabMenuType *cell = (CustomCollectionViewCellTabMenuType *)[colVwTabIngredientType cellForItemAtIndexPath:indexPath];
        [cell removeGestureRecognizer:cell.longPressGestureRecognizer];
        [cell.longPressGestureRecognizer addTarget:self action:@selector(handleLongPressTabIngredientType:)];
        [cell addGestureRecognizer:cell.longPressGestureRecognizer];
    }
    
    for(int i=0; i<[_arrOfIngredientList count]; i++)
    {
        NSMutableArray *ingredientList = _arrOfIngredientList[i];
        for(int j=0; j<[ingredientList count]; j++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            CustomCollectionViewCellMenuWithTakeAway *cell = (CustomCollectionViewCellMenuWithTakeAway *)[colVwIngredient cellForItemAtIndexPath:indexPath];
            [cell removeGestureRecognizer:cell.longPressGestureRecognizer];
            [cell.longPressGestureRecognizer addTarget:self action:@selector(handleLongPressIngredient:)];
            [cell addGestureRecognizer:cell.longPressGestureRecognizer];
        }
    }
}

- (IBAction)reorderSection:(id)sender
{
    UIView *headerView;
    if([_arrOfIngredientList count]>0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        headerView = [colVwIngredient supplementaryViewForElementKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        
    }
    if(!headerView)
    {
        return;
    }
    
    
    
    // grab the view controller we want to show
    IngredientType *ingredientType = _ingredientTypeList[_selectedIndexIngredientType];
    NSMutableArray *subIngredientTypeList = [SubIngredientType getSubIngredientTypeListWithIngredientTypeID:ingredientType.ingredientTypeID];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SubIngredientTypeReorderViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"SubIngredientTypeReorderViewController"];
    controller.preferredContentSize = CGSizeMake(300, 44*[subIngredientTypeList count]+58+60);
    controller.vc = self;
    controller.subIngredientTypeList = subIngredientTypeList;
    
    
    // present the controller
    // on iPad, this will be a Popover
    // on iPhone, this will be an action sheet
    controller.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:controller animated:YES completion:nil];
    
    // configure the Popover presentation controller
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.delegate = self;
    
    
    
    CGRect frame = headerView.frame;
    frame.origin.y = frame.origin.y-15;
    popController.sourceView = headerView;
    popController.sourceRect = frame;
}

- (IBAction)addEditSection:(id)sender//add subMenuType
{
    [self addSubIngredientType];
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

- (IBAction)showAllSubIngredientType:(id)sender
{
    if([btnShowAllSubIngredientType.titleLabel.text isEqualToString:@"แสดงทั้งหมด"])
    {
        [btnShowAllSubIngredientType setTitle:@"เฉพาะที่ใช้อยู่" forState:UIControlStateNormal];
        [btnShowAllSubIngredientType setSelected:NO];
    }
    else
    {
        [btnShowAllSubIngredientType setTitle:@"แสดงทั้งหมด" forState:UIControlStateNormal];
        [btnShowAllSubIngredientType setSelected:YES];
    }
    [self loadViewProcess];
}

-(void)addIngredientType:(id)sender
{
    [self addIngredientType];
}

-(void)addIngredientType
{
    // grab the view controller we want to show
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    IngredientTypeViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"IngredientTypeViewController"];
    controller.preferredContentSize = CGSizeMake(300, 44*2+58+60);
    controller.vc = self;
    controller.editIngredientType = nil;
    
    
    
    // present the controller
    // on iPad, this will be a Popover
    // on iPhone, this will be an action sheet
    controller.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:controller animated:YES completion:nil];
    
    // configure the Popover presentation controller
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.delegate = self;
    
    
    CGRect frame = colVwTabIngredientType.frame;
    frame.origin.y = frame.origin.y-15;
    popController.sourceView = colVwTabIngredientType;
    popController.sourceRect = frame;
}

-(void)setMenuIngredient
{
    //get ingredient
    _menuIngredientList = [MenuIngredient getMenuIngredientListWithMenuID:editMenu.menuID];
    NSMutableArray *allIngredientList = [[NSMutableArray alloc]init];
    for(MenuIngredient *item in _menuIngredientList)
    {
        Ingredient *ingredient = [Ingredient getIngredient:item.ingredientID];
        [allIngredientList addObject:ingredient];
    }
    
    
    NSSet *ingredientTypeIDSet = [NSSet setWithArray:[allIngredientList valueForKey:@"_ingredientTypeID"]];
    [_selectedIngredientTypeList removeAllObjects];
    for(NSNumber *item in ingredientTypeIDSet)
    {
        IngredientType *ingredientType = [IngredientType getIngredientType:[item integerValue]];
        [_selectedIngredientTypeList addObject:ingredientType];
    }
    
    
    [_selectedArrOfIngredientList removeAllObjects];
    _selectedIngredientTypeList = [IngredientType sort:_selectedIngredientTypeList];
    for(IngredientType *item in _selectedIngredientTypeList)
    {
        NSMutableArray *ingredientList = [Ingredient getIngredientListWithIngredientTypeID:item.ingredientTypeID ingredientList:allIngredientList];;
        [_selectedArrOfIngredientList addObject:ingredientList];
    }
    
    
    [tbvMenuIngredient reloadData];
}

-(void)addSubIngredientType
{
    // grab the view controller we want to show
    IngredientType *ingredientType = _ingredientTypeList[_selectedIndexIngredientType];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SubIngredientTypeViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"SubIngredientTypeViewController"];
    controller.preferredContentSize = CGSizeMake(300, 44*2+58+60);
    controller.vc = self;
    controller.editIngredientType = ingredientType;
    controller.editSubIngredientType = nil;
    
    
    // present the controller
    // on iPad, this will be a Popover
    // on iPhone, this will be an action sheet
    controller.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:controller animated:YES completion:nil];
    
    // configure the Popover presentation controller
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.delegate = self;
    
    
    CGRect frame = colVwIngredient.frame;
    frame.origin.y = frame.origin.y-15;
    popController.sourceView = colVwIngredient;
    popController.sourceRect = frame;
}

- (void)itemsDownloaded:(NSArray *)items
{
    [super itemsDownloaded:items];
    
    if(self.homeModel.propCurrentDB == dbIngredientType)
    {
        [IngredientType setIngredientTypeList:[items[0] mutableCopy]];
        [self removeOverlayViews];
        
        
        [self loadViewProcess];
    }
    else if(self.homeModel.propCurrentDB == dbIngredient)
    {
        [Ingredient setIngredientList:[items[0] mutableCopy]];
        [self removeOverlayViews];
        
        
        [self loadViewProcess];
    }
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    
    // return YES if the Popover should be dismissed
    // return NO if the Popover should not be dismissed
    return NO;
}

-(void)addIngredient:(id)sender
{
    UIView *button = sender;
    NSInteger subIngredientTypeID = button.tag;
    
    
    IngredientType *ingredientType = _ingredientTypeList[_selectedIndexIngredientType];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    IngredientViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"IngredientViewController"];
    controller.preferredContentSize = CGSizeMake(300, 44*5+58);
    controller.vc = self;
    controller.editIngredient = nil;
    controller.editIngredientType = ingredientType;
    if(subIngredientTypeID == -1)
    {
        controller.editSubIngredientType = nil;
    }
    else
    {
        controller.editSubIngredientType = [SubIngredientType getSubIngredientType:subIngredientTypeID];
    }
    
    
    // present the controller
    // on iPad, this will be a Popover
    // on iPhone, this will be an action sheet
    controller.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:controller animated:YES completion:nil];
    
    // configure the Popover presentation controller
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.delegate = self;
    
    
    CGRect frame = colVwIngredient.frame;
    frame.origin.y = frame.origin.y-15;
    popController.sourceView = colVwIngredient;
    popController.sourceRect = frame;

}
@end
