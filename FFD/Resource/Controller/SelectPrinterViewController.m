//
//  SelectPrinterViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 25/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SelectPrinterViewController.h"
#import "Printer.h"
#import "Setting.h"


@interface SelectPrinterViewController ()
{
    NSMutableArray *_printerList;
}
@end

@implementation SelectPrinterViewController
@synthesize tbvSelectPrinter;
@synthesize vc;



-(void)loadView
{
    [super loadView];
    _printerList = [Printer getPrinterList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    tbvSelectPrinter.dataSource = self;
    tbvSelectPrinter.delegate = self;
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];
    
    
    [tapGesture setCancelsTouchesInView:NO];
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return [_printerList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger item = indexPath.item;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Printer *printer = _printerList[item];
    cell.textLabel.text = printer.name;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Printer *printer = _printerList[indexPath.item];
    Setting *setting = [Setting getSettingWithKeyName:@"foodCheckList"];
    setting.value = [NSString stringWithFormat:@"%ld",printer.printerID];
    setting.modifiedUser = [Utility modifiedUser];
    setting.modifiedDate = [Utility currentDateTime];
    [self.homeModel updateItems:dbSetting withData:setting actionScreen:@"update foodCheckList in selectPrinter screen"];
    [self dismissViewControllerAnimated:YES completion:^{
        [vc setFoodCheckListTextBox:printer.name];
    }];
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
@end
