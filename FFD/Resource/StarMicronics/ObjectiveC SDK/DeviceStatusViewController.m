//
//  DeviceStatusViewController.m
//  ObjectiveC SDK
//
//  Created by Yuji on 2016/**/**.
//  Copyright © 2016年 Star Micronics. All rights reserved.
//

#import "DeviceStatusViewController.h"

#import "AppDelegate.h"

#import <StarIO/SMPort.h>

typedef NS_ENUM(NSUInteger, CellParamIndex) {
    CellParamIndexTitleIndex = 0,
    CellParamIndexDetailIndex,
    CellParamIndexColorIndex
};

@interface DeviceStatusViewController ()

@property (nonatomic) NSMutableArray *cellArray;

@property (nonatomic) BOOL didAppear;

- (void)refreshDeviceStatus;

@end

@implementation DeviceStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self appendRefreshButton:@selector(refreshDeviceStatus)];
    
    _cellArray = [[NSMutableArray alloc] init];
    
    _didAppear = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_didAppear == NO) {
        [self refreshDeviceStatus];
        
        _didAppear = YES;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return _cellArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"UITableViewCellStyleValue1";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    if (cell != nil) {
        NSArray *cellParam = _cellArray[indexPath.row];
        
        cell.      textLabel.text      = cellParam[CellParamIndexTitleIndex];
        cell.detailTextLabel.text      = cellParam[CellParamIndexDetailIndex];
        cell.detailTextLabel.textColor = cellParam[CellParamIndexColorIndex];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Contents";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)refreshDeviceStatus {
    BOOL result = NO;
    
    self.blind = YES;
    
    [_cellArray removeAllObjects];
    
    SMPort *port = nil;
    
    @try {
        while (YES) {
            port = [SMPort getPort:[AppDelegate getPortName] :[AppDelegate getPortSettings] :10000];     // 10000mS!!!
            
            if (port == nil) {
                break;
            }
            
            StarPrinterStatus_2 printerStatus;
            
            [port getParsedStatus:&printerStatus :2];
            
            if (printerStatus.offline == SM_TRUE) {
                [_cellArray addObject:@[@"Online", @"Offline", [UIColor redColor]]];
            }
            else {
                [_cellArray addObject:@[@"Online", @"Online",  [UIColor blueColor]]];
            }
            
            if (printerStatus.coverOpen == SM_TRUE) {
                [_cellArray addObject:@[@"Cover", @"Open",   [UIColor redColor]]];
            }
            else {
                [_cellArray addObject:@[@"Cover", @"Closed", [UIColor blueColor]]];
            }
            
            if (printerStatus.receiptPaperEmpty == SM_TRUE) {
                [_cellArray addObject:@[@"Paper", @"Empty", [UIColor redColor]]];
            }
            else if (printerStatus.receiptPaperNearEmptyInner == SM_TRUE ||
                     printerStatus.receiptPaperNearEmptyOuter == SM_TRUE) {
                [_cellArray addObject:@[@"Paper", @"Near Empty", [UIColor orangeColor]]];
            }
            else {
                [_cellArray addObject:@[@"Paper", @"Ready",      [UIColor blueColor]]];
            }
            
            if ([AppDelegate getCashDrawerOpenActiveHigh] == YES) {
                if (printerStatus.compulsionSwitch == SM_TRUE) {
                    [_cellArray addObject:@[@"Cash Drawer", @"Open",   [UIColor redColor]]];
                }
                else {
                    [_cellArray addObject:@[@"Cash Drawer", @"Closed", [UIColor blueColor]]];
                }
            }
            else {
                if (printerStatus.compulsionSwitch == SM_TRUE) {
                    [_cellArray addObject:@[@"Cash Drawer", @"Closed", [UIColor blueColor]]];
                }
                else {
                    [_cellArray addObject:@[@"Cash Drawer", @"Open",   [UIColor redColor]]];
                }
            }
            
            if (printerStatus.overTemp == SM_TRUE) {
                [_cellArray addObject:@[@"Head Temperature", @"High",   [UIColor redColor]]];
            }
            else {
                [_cellArray addObject:@[@"Head Temperature", @"Normal", [UIColor blueColor]]];
            }
            
            if (printerStatus.unrecoverableError == SM_TRUE) {
                [_cellArray addObject:@[@"Non Recoverable Error", @"Occurs", [UIColor redColor]]];
            }
            else {
                [_cellArray addObject:@[@"Non Recoverable Error", @"Ready",  [UIColor blueColor]]];
            }
            
            if (printerStatus.cutterError == SM_TRUE) {
                [_cellArray addObject:@[@"Paper Cutter", @"Error", [UIColor redColor]]];
            }
            else {
                [_cellArray addObject:@[@"Paper Cutter", @"Ready", [UIColor blueColor]]];
            }
            
            if (printerStatus.headThermistorError == SM_TRUE) {
                [_cellArray addObject:@[@"Head Thermistor", @"Error",  [UIColor redColor]]];
            }
            else {
                [_cellArray addObject:@[@"Head Thermistor", @"Normal", [UIColor blueColor]]];
            }
            
            if (printerStatus.voltageError == SM_TRUE) {
                [_cellArray addObject:@[@"Voltage", @"Error",  [UIColor redColor]]];
            }
            else {
                [_cellArray addObject:@[@"Voltage", @"Normal", [UIColor blueColor]]];
            }
            
            if (printerStatus.etbAvailable == SM_TRUE) {
                [_cellArray addObject:@[@"ETB Counter", [NSString stringWithFormat:@"%d", printerStatus.etbCounter], [UIColor blueColor]]];
            }
            
            result = YES;
            break;
        }
    }
    @catch (PortException *exc) {
    }
    @finally {
        if (port != nil) {
            [SMPort releasePort:port];
            
            port = nil;
        }
    }
    
    if (result == NO) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Fail to Open Port" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
    }
    
    [self.tableView reloadData];
    
    self.blind = NO;
}

@end
