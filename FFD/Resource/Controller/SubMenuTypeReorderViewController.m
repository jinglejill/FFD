//
//  SubMenuTypeReorderViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/17/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SubMenuTypeReorderViewController.h"
#import "MenuViewController.h"
#import "SubMenuType.h"


@interface SubMenuTypeReorderViewController ()
{
//    NSMutableArray *_subMenuTypeList;
}

@end

@implementation SubMenuTypeReorderViewController


@synthesize tbvSubMenuType;
@synthesize vwConfirmAndCancel;
@synthesize vc;
@synthesize subMenuTypeList;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [tbvSubMenuType setEditing:YES animated:YES];
    tbvSubMenuType.dataSource = self;
    tbvSubMenuType.delegate = self;
    


    //add ยืนยัน กับ ยกเลิก button
    [[NSBundle mainBundle] loadNibNamed:@"ConfirmAndCancelView" owner:self options:nil];
    tbvSubMenuType.tableFooterView = vwConfirmAndCancel;
    [vwConfirmAndCancel.btnConfirm addTarget:self action:@selector(addEditSubMenuType:) forControlEvents:UIControlEventTouchUpInside];
    [vwConfirmAndCancel.btnCancel addTarget:self action:@selector(cancelSubMenuType:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return [subMenuTypeList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger item = indexPath.item;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SubMenuType *subMenuType = subMenuTypeList[item];
    cell.textLabel.text = subMenuType.name;
    if(subMenuType.status)
    {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    else
    {
        cell.textLabel.textColor = mGrayColor;
    }
    
    
    return cell;
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

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    //    if (indexPath.row == 0) // Don't move the first row
    //        return NO;
    
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    SubMenuType *subMenuType = subMenuTypeList[sourceIndexPath.item];
    [subMenuTypeList removeObjectAtIndex:sourceIndexPath.item];
    [subMenuTypeList insertObject:subMenuType atIndex:destinationIndexPath.item];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)addEditSubMenuType:(id)sender
{
    //check idinserted
    {
        for(SubMenuType *item in subMenuTypeList)
        {
            if(!item.idInserted)
            {
                [self showAlertAndCallPushSync:@"" message:@"ไม่สามารถจัดลำดับหมวดหมู่ย่อยได้ กรุณาลองใหม่อีกครั้ง"];
                return;
            }
        }
    }
    
    
    int i=0;
    for(SubMenuType *item in subMenuTypeList)
    {
        item.orderNo = i;
        item.modifiedUser = [Utility modifiedUser];
        item.modifiedDate = [Utility currentDateTime];
        i++;
    }
    [self.homeModel updateItems:dbSubMenuTypeList withData:subMenuTypeList actionScreen:@"reorder submenutype in menu screen"];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [vc showAlert:@"" message:@"จัดลำดับหมวดหมู่ย่อยสำเร็จ"];
        [vc loadViewProcess];
    }];
    
    
}

- (void)cancelSubMenuType:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
