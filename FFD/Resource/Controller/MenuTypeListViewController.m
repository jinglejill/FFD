//
//  MenuTypeListViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 26/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "MenuTypeListViewController.h"
#import "MenuType.h"

@interface MenuTypeListViewController ()
{
    NSMutableArray *_menuTypeList;
}
@end

@implementation MenuTypeListViewController
@synthesize tbvMenuType;
@synthesize selectedPrinter;
@synthesize vc;
@synthesize vwConfirmAndCancel;


-(void)loadView
{
    [super loadView];
    _menuTypeList = [MenuType getMenuTypeListWithStatus:1];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    tbvMenuType.dataSource = self;
    tbvMenuType.delegate = self;
    tbvMenuType.allowsMultipleSelection = YES;
    tbvMenuType.allowsSelection = YES;
    
    
    //add ยืนยัน กับ ยกเลิก button
    [[NSBundle mainBundle] loadNibNamed:@"ConfirmAndCancelView" owner:self options:nil];
    tbvMenuType.tableFooterView = vwConfirmAndCancel;
    [vwConfirmAndCancel.btnConfirm addTarget:self action:@selector(confirmSelectMenuType:) forControlEvents:UIControlEventTouchUpInside];
    [vwConfirmAndCancel.btnCancel addTarget:self action:@selector(cancelSelectMenuType:) forControlEvents:UIControlEventTouchUpInside];
    
    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
//    [self.view addGestureRecognizer:tapGesture];
//    [tapGesture setCancelsTouchesInView:NO];
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return [_menuTypeList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger item = indexPath.item;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }

    MenuType *menuType = _menuTypeList[item];
    cell.textLabel.text = menuType.name;
    cell.textLabel.textColor = [UIColor blackColor];
    NSMutableArray *disableMenuTypeList = [Printer getMenuTypeListOtherThanPrinter:selectedPrinter];
    for(MenuType *item in disableMenuTypeList)
    {
        if(item.menuTypeID == menuType.menuTypeID)
        {
            cell.textLabel.textColor = [UIColor grayColor];
            break;
        }
    }
    
    
    //in case of reuse cell -> set to normal first then change if selected
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor clearColor];
    [cell setSelectedBackgroundView:bgColorView];
    cell.textLabel.textColor = [UIColor blackColor];
    
    NSMutableArray *highLightMenuTypeList = [Printer getMenuTypeListWithPrinter:selectedPrinter];
    for(MenuType *item in highLightMenuTypeList)
    {
        if(item.menuTypeID == menuType.menuTypeID)
        {
            [tbvMenuType selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            UIView *bgColorView = [[UIView alloc] init];
            bgColorView.backgroundColor = mGreen;
            [cell setSelectedBackgroundView:bgColorView];
            cell.textLabel.textColor = [UIColor whiteColor];
            break;
        }
    }
    
    
    
    return cell;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{

}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuType *menuType = _menuTypeList[indexPath.item];
    NSMutableArray *disableMenuTypeList = [Printer getMenuTypeListOtherThanPrinter:selectedPrinter];
    for(MenuType *item in disableMenuTypeList)
    {
        if(item.menuTypeID == menuType.menuTypeID)
        {
            return NO;
        }
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tbvMenuType cellForRowAtIndexPath:indexPath];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = mGreen;
    [cell setSelectedBackgroundView:bgColorView];
    cell.textLabel.textColor = [UIColor whiteColor];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tbvMenuType cellForRowAtIndexPath:indexPath];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor clearColor];
    [cell setSelectedBackgroundView:bgColorView];
    cell.textLabel.textColor = [UIColor blackColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(void)confirmSelectMenuType:(id)sender
{
    NSString *strMenuTypeIDListInText = @"";
    NSArray *indexPathList = [tbvMenuType indexPathsForSelectedRows];
    int i=0;
    for(NSIndexPath *indexPath in indexPathList)
    {
        MenuType *menuType = _menuTypeList[indexPath.item];
        if(i == 0)
        {
            strMenuTypeIDListInText = [NSString stringWithFormat:@"%ld",(long)menuType.menuTypeID];
        }
        else
        {
            strMenuTypeIDListInText = [NSString stringWithFormat:@"%@,%ld",strMenuTypeIDListInText,(long)menuType.menuTypeID];
        }
        
        i++;
    }
    selectedPrinter.menuTypeIDListInText = strMenuTypeIDListInText;
    selectedPrinter.modifiedUser = [Utility modifiedUser];
    selectedPrinter.modifiedDate = [Utility currentDateTime];
    [self.homeModel updateItems:dbPrinter withData:selectedPrinter actionScreen:@"update printer menuTypeIDListInText in menuTypeList screen"];
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        [vc reloadCollectionView];
    }];
}

-(void)cancelSelectMenuType:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
@end
