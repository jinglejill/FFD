//
//  SettingListViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 11/10/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SettingListViewController.h"
#import "SettingDetailViewController.h"
#import "CustomSettingViewController.h"



@interface SettingListViewController ()
{
    NSInteger _selectedIndexSettingGroup;
}
@end

@implementation SettingListViewController
@synthesize tbvSettingNameList;



- (void)viewDidLayoutSubviews
{
    CGRect frame = tbvSettingNameList.frame;
    frame.size.height = frame.size.height-200;
    tbvSettingNameList.frame = frame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    tbvSettingNameList.dataSource = self;
    tbvSettingNameList.delegate = self;
    
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture setCancelsTouchesInView:NO];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    switch (indexPath.item) {
        case 0:
            cell.textLabel.text = @"เครื่องพิมพ์";
            break;
        case 1:
            cell.textLabel.text = @"โต๊ะอาหาร";
            break;
        case 2:
            cell.textLabel.text = @"โปรโมชั่น";
            break;
        case 3:
            cell.textLabel.text = @"โปรแกรมสะสมแต้ม";
            break;
        case 4:
            cell.textLabel.text = @"ส่วนลด";
            break;
        case 5:
            cell.textLabel.text = @"เมนูที่ผู้ใช้มีสิทธิ์ใช้";
            break;
        default:
            break;
    }
    
    if(_selectedIndexSettingGroup == indexPath.item)
    {
        cell.backgroundColor = mLightBlueColor;
    }
    else
    {
        cell.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = mBlueColor;
    
    _selectedIndexSettingGroup = indexPath.item;
    [self sendParamToSettingDetail];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
}

- (void)loadView
{
    [super loadView];
    
    
    _selectedIndexSettingGroup = 0;
    
    
    [self loadViewProcess];
}

- (void)loadViewProcess
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_selectedIndexSettingGroup inSection:0];
    [tbvSettingNameList selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

-(void)sendParamToSettingDetail
{
    UINavigationController *nav = self.splitViewController.viewControllers[1];
    CustomSettingViewController *vc = (CustomSettingViewController *)nav.topViewController;
    vc.settingGroup = (enum settingGroup)_selectedIndexSettingGroup;
    [vc unwindToSettingDetail];
    
}
@end
