//
//  SearchPortViewController.m
//  ObjectiveC SDK
//
//  Created by Yuji on 2015/**/**.
//  Copyright (c) 2015年 Star Micronics. All rights reserved.
//

#import "SearchPortViewController.h"
#import "AppDelegate.h"
#import "ModelCapability.h"

#import <StarIO/SMPort.h>
//#import "Setting.h"
#import "Printer.h"


typedef NS_ENUM(NSInteger, CellParamIndex) {
    CellParamIndexPortName = 0,
    CellParamIndexModelName,
    CellParamIndexMacAddress
};

typedef NS_ENUM(NSInteger, AlertViewIndex) {
    AlertViewIndexRefreshPort = 0,
    AlertViewIndexPortName,
    AlertViewIndexPortSettings,
    AlertViewIndexModelConfirm,
    AlertViewIndexModelSelect0,
    AlertViewIndexModelSelect1,
    AlertViewIndexCashDrawerOpenActive
};

@interface SearchPortViewController ()
@property (nonatomic) NSMutableArray *cellArray;

@property (nonatomic) NSIndexPath *selectedIndexPath;

@property (nonatomic) BOOL didAppear;

@property (nonatomic) NSString *portName;
@property (nonatomic) NSString *portSettings;
@property (nonatomic) NSString *modelName;
@property (nonatomic) NSString *macAddress;

@property (nonatomic) StarIoExtEmulation emulation;

- (void)refreshPortInfo;

@end

@implementation SearchPortViewController
@synthesize customVc;
@synthesize printerPortKey;
@synthesize printerPort;
@synthesize printer;
@synthesize selectPrinter;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self appendRefreshButton:@selector(refreshPortInfo)];
    
    _cellArray = [[NSMutableArray alloc] init];
    
    _selectedIndexPath = nil;
    
    _didAppear = NO;
    
    _tableView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_didAppear == NO) {
        [self refreshPortInfo];
        
        _didAppear = YES;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return _cellArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"UITableViewCellStyleSubtitle";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if (cell != nil) {
        NSArray *cellParam = _cellArray[indexPath.row];
        
//      cell.      textLabel.text = cellParam[CellParamIndexPortName];
        cell.      textLabel.text = cellParam[CellParamIndexModelName];
//      cell.detailTextLabel.text = cellParam[CellParamIndexModelName];
        
        if ([cellParam[CellParamIndexMacAddress] isEqualToString:@""]) {
            cell.detailTextLabel.text = cellParam[CellParamIndexPortName];
        }
        else {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%@)", cellParam[CellParamIndexPortName], cellParam[CellParamIndexMacAddress]];
        }
        
        cell.      textLabel.textColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if (_selectedIndexPath != nil) {
            if ([indexPath compare:_selectedIndexPath] == NSOrderedSame) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"List";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//  [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell;
    
    if (_selectedIndexPath != nil) {
        cell = [tableView cellForRowAtIndexPath:_selectedIndexPath];
        
        if (cell != nil) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    _selectedIndexPath = indexPath;
    
    NSArray *cellParam = _cellArray[_selectedIndexPath.row];
    
//  NSString *portName   = cellParam[CellParamIndexPortName];
    NSString *modelName  = cellParam[CellParamIndexModelName];
//  NSString *macAddress = cellParam[CellParamIndexMacAddress];
    
    if (false) {     // Ex1. Direct Setting.
//      NSString           *portSettings = @"";
//      NSString           *portSettings = @"mini";
//      NSString           *portSettings = @"escpos";
//      NSString           *portSettings = @"Portable";
//
//      StarIoExtEmulation  emulation = StarIoExtEmulationStarPRNT;
//      StarIoExtEmulation  emulation = StarIoExtEmulationStarLine;
//      StarIoExtEmulation  emulation = StarIoExtEmulationStarGraphic;
//      StarIoExtEmulation  emulation = StarIoExtEmulationEscPos;
//      StarIoExtEmulation  emulation = StarIoExtEmulationEscPosMobile;
//      StarIoExtEmulation  emulation = StarIoExtEmulationStarDotImpact;
//
//      [AppDelegate setPortName    :portName];
//      [AppDelegate setModelName   :modelName];
//      [AppDelegate setMacAddress  :macAddress];
//      [AppDelegate setPortSettings:portSettings];
//      [AppDelegate setEmulation   :emulation];
//
//      [self.navigationController popViewControllerAnimated:YES];
    }
    else if (false) {     // Ex2. Direct Setting.
//      ModelIndex modelIndex = ModelIndexMPOP;
//      ModelIndex modelIndex = ModelIndexFVP10;
//      ModelIndex modelIndex = ModelIndexTSP100;
//      ModelIndex modelIndex = ModelIndexTSP650II;
//      ModelIndex modelIndex = ModelIndexTSP700II;
//      ModelIndex modelIndex = ModelIndexTSP800II;
//      ModelIndex modelIndex = ModelIndexSM_S210I;
//      ModelIndex modelIndex = ModelIndexSM_S220I;
//      ModelIndex modelIndex = ModelIndexSM_S230I;
//      ModelIndex modelIndex = ModelIndexSM_T300I;
//      ModelIndex modelIndex = ModelIndexSM_T400I;
//      ModelIndex modelIndex = ModelIndexBSC10;
//      ModelIndex modelIndex = ModelIndexSM_S210I_StarPRNT;
//      ModelIndex modelIndex = ModelIndexSM_S220I_StarPRNT;
//      ModelIndex modelIndex = ModelIndexSM_S230I_StarPRNT;
//      ModelIndex modelIndex = ModelIndexSM_T300I_StarPRNT;
//      ModelIndex modelIndex = ModelIndexSM_T400I_StarPRNT;
//      ModelIndex modelIndex = ModelIndexSM_L200;
//      ModelIndex modelIndex = ModelIndexSP700;
//
//      NSString           *portSettings = [ModelCapability portSettingsAtModelIndex:modelIndex];
//      StarIoExtEmulation  emulation    = [ModelCapability emulationAtModelIndex   :modelIndex];
//
//      [AppDelegate setPortName    :portName];
//      [AppDelegate setModelName   :modelName];
//      [AppDelegate setMacAddress  :macAddress];
//      [AppDelegate setPortSettings:portSettings];
//      [AppDelegate setEmulation   :emulation];
//
//      [self.navigationController popViewControllerAnimated:YES];
    }
    else if (false) {     // Ex3. Indirect Setting.
//      ModelIndex modelIndex = [ModelCapability modelIndexAtModelName:modelName];
//
//      NSString           *portSettings = [ModelCapability portSettingsAtModelIndex:modelIndex];
//      StarIoExtEmulation  emulation    = [ModelCapability emulationAtModelIndex   :modelIndex];
//
//      [AppDelegate setPortName    :portName];
//      [AppDelegate setModelName   :modelName];
//      [AppDelegate setMacAddress  :macAddress];
//      [AppDelegate setPortSettings:portSettings];
//      [AppDelegate setEmulation   :emulation];
//
//      [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {     // Ex4. Indirect Setting
    
    
    
        ModelIndex modelIndex = [ModelCapability modelIndexAtModelName:modelName];
        
        if (modelIndex != ModelIndexNone) {
            NSString *message = [NSString stringWithFormat:@"Is your printer %@?", [ModelCapability titleAtModelIndex:modelIndex]];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirm." message:message delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
            
            alertView.tag = AlertViewIndexModelConfirm;
            
            [alertView show];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirm." message:@"What is your printer?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            
            for (int i = 0; i < [ModelCapability modelIndexCount]; i++) {
                [alertView addButtonWithTitle:[ModelCapability titleAtModelIndex:[ModelCapability modelIndexAtIndex:i]]];
            }
            
            alertView.tag = AlertViewIndexModelSelect0;
            
            [alertView show];
        }
    }
}

- (void)refreshPortInfo
{
    {
        self.blind = YES;
        
        [_cellArray removeAllObjects];
        
        _selectedIndexPath = nil;
        
        NSArray *portInfoArray;
        
        portInfoArray = [SMPort searchPrinter:@"TCP:"];
        
        NSString *portName   = [AppDelegate getPortName];
        NSString *modelName  = [AppDelegate getModelName];
        NSString *macAddress = [AppDelegate getMacAddress];
        
        int row = 0;
        
        for (PortInfo *portInfo in portInfoArray) {
            [_cellArray addObject:@[portInfo.portName, portInfo.modelName, portInfo.macAddress]];
            
            if ([portInfo.portName   isEqualToString:portName]   == YES &&
                [portInfo.modelName  isEqualToString:modelName]  == YES &&
                [portInfo.macAddress isEqualToString:macAddress] == YES) {
                _selectedIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
            }
            
            row++;
        }
        
        [_tableView reloadData];
        
        self.blind = NO;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == AlertViewIndexPortName) {
        if (buttonIndex == alertView.cancelButtonIndex) {
            alertView.delegate = nil;
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            _portName = [alertView textFieldAtIndex:0].text;
            
            if ([_portName isEqualToString:@""]) {
                UIAlertView *nestAlertView = [[UIAlertView alloc] initWithTitle:@"Please enter the port name." message:@"Fill in the port name." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
                
                nestAlertView.tag            = AlertViewIndexPortName;
                nestAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                
                [nestAlertView textFieldAtIndex:0].text = [AppDelegate getPortName];
                
                [nestAlertView show];
            }
            else {
                UIAlertView *nestAlertView = [[UIAlertView alloc] initWithTitle:@"Please enter the port settings." message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
                
                nestAlertView.tag            = AlertViewIndexPortSettings;
                nestAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                
                [nestAlertView textFieldAtIndex:0].text = [AppDelegate getPortSettings];
                
                [nestAlertView show];
            }
        }
    }
    else if (alertView.tag == AlertViewIndexPortSettings) {
        if (buttonIndex == alertView.cancelButtonIndex) {
            alertView.delegate = nil;
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            _portSettings = [alertView textFieldAtIndex:0].text;
            
            UIAlertView *nestAlertView = [[UIAlertView alloc] initWithTitle:@"Confirm." message:@"What is your printer?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            
            for (int i = 0; i < [ModelCapability modelIndexCount]; i++) {
                [nestAlertView addButtonWithTitle:[ModelCapability titleAtModelIndex:[ModelCapability modelIndexAtIndex:i]]];
            }
            
            nestAlertView.tag = AlertViewIndexModelSelect1;
            
            [nestAlertView show];
        }
    }
    else if (alertView.tag == AlertViewIndexModelConfirm) {
        if (buttonIndex == 1) {     // YES!!!
            NSArray *cellParam = _cellArray[_selectedIndexPath.row];
            
            _portName   = cellParam[CellParamIndexPortName];
            _modelName  = cellParam[CellParamIndexModelName];
            _macAddress = cellParam[CellParamIndexMacAddress];
            
            ModelIndex modelIndex = [ModelCapability modelIndexAtModelName:_modelName];
            
            _portSettings = [ModelCapability portSettingsAtModelIndex:modelIndex];
            _emulation    = [ModelCapability emulationAtModelIndex   :modelIndex];
            
            if ([ModelCapability cashDrawerOpenActiveAtModelIndex:modelIndex] == YES) {
                UIAlertView *nestAlertView = [[UIAlertView alloc] initWithTitle:@"Select CashDrawer Open Status."
                                                                        message:@""
                                                                       delegate:self
                                                              cancelButtonTitle:@"Cancel"
                                                              otherButtonTitles:@"High when Open", @"Low when Open", nil];
                
                nestAlertView.tag = AlertViewIndexCashDrawerOpenActive;
                
                [nestAlertView show];
            }
            else {
                [AppDelegate setPortName                :_portName];
                [AppDelegate setPortSettings            :_portSettings];
                [AppDelegate setModelName               :_modelName];
                [AppDelegate setMacAddress              :_macAddress];
                [AppDelegate setEmulation               :_emulation];
                [AppDelegate setCashDrawerOpenActiveHigh:YES];
                
                alertView.delegate = nil;
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else {     // NO!!!
            UIAlertView *nestAlertView = [[UIAlertView alloc] initWithTitle:@"Confirm." message:@"What is your printer?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            
            for (int i = 0; i < [ModelCapability modelIndexCount]; i++) {
                [nestAlertView addButtonWithTitle:[ModelCapability titleAtModelIndex:[ModelCapability modelIndexAtIndex:i]]];
            }
            
            nestAlertView.tag = AlertViewIndexModelSelect0;
            
            [nestAlertView show];
        }
    }
    else if (alertView.tag == AlertViewIndexModelSelect0) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            NSArray *cellParam = _cellArray[_selectedIndexPath.row];
            
            _portName   = cellParam[CellParamIndexPortName];
            _modelName  = cellParam[CellParamIndexModelName];
            _macAddress = cellParam[CellParamIndexMacAddress];
            
            ModelIndex modelIndex = [ModelCapability modelIndexAtIndex:buttonIndex - 1];
            
            _portSettings = [ModelCapability portSettingsAtModelIndex:modelIndex];
            _emulation    = [ModelCapability emulationAtModelIndex   :modelIndex];
            
            if ([ModelCapability cashDrawerOpenActiveAtModelIndex:modelIndex] == YES) {
                UIAlertView *nestAlertView = [[UIAlertView alloc] initWithTitle:@"Select CashDrawer Open Status."
                                                                        message:@""
                                                                       delegate:self
                                                              cancelButtonTitle:@"Cancel"
                                                              otherButtonTitles:@"High when Open", @"Low when Open", nil];
                
                nestAlertView.tag = AlertViewIndexCashDrawerOpenActive;
                
                [nestAlertView show];
            }
            else {
                [AppDelegate setPortName                :_portName];
                [AppDelegate setPortSettings            :_portSettings];
                [AppDelegate setModelName               :_modelName];
                [AppDelegate setMacAddress              :_macAddress];
                [AppDelegate setEmulation               :_emulation];
                [AppDelegate setCashDrawerOpenActiveHigh:YES];
                
                alertView.delegate = nil;
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
    else if (alertView.tag == AlertViewIndexModelSelect1) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            ModelIndex modelIndex = [ModelCapability modelIndexAtIndex:buttonIndex - 1];
            
            _modelName    = [ModelCapability titleAtModelIndex       :modelIndex];
            _macAddress   = _portSettings;                                             // for display.
//          _portSettings = [ModelCapability portSettingsAtModelIndex:modelIndex];
            _emulation    = [ModelCapability emulationAtModelIndex   :modelIndex];
            
            if ([ModelCapability cashDrawerOpenActiveAtModelIndex:modelIndex] == YES) {
                UIAlertView *nestAlertView = [[UIAlertView alloc] initWithTitle:@"Select CashDrawer Open Status."
                                                                        message:@""
                                                                       delegate:self
                                                              cancelButtonTitle:@"Cancel"
                                                              otherButtonTitles:@"High when Open", @"Low when Open", nil];
                
                nestAlertView.tag = AlertViewIndexCashDrawerOpenActive;
                
                [nestAlertView show];
            }
            else {
                [AppDelegate setPortName                :_portName];
                [AppDelegate setPortSettings            :_portSettings];
                [AppDelegate setModelName               :_modelName];
                [AppDelegate setMacAddress              :_macAddress];
                [AppDelegate setEmulation               :_emulation];
                [AppDelegate setCashDrawerOpenActiveHigh:YES];
                
                alertView.delegate = nil;
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
    else if (alertView.tag == AlertViewIndexCashDrawerOpenActive) {
//        if (buttonIndex != alertView.cancelButtonIndex)
        {
            [AppDelegate setPortName    :_portName];
            [AppDelegate setPortSettings:_portSettings];
            [AppDelegate setModelName   :_modelName];
            [AppDelegate setMacAddress  :_macAddress];
            [AppDelegate setEmulation   :_emulation];
            
            if (buttonIndex == 1) {     // High when Open
                [AppDelegate setCashDrawerOpenActiveHigh:YES];
            }
            else if (buttonIndex == 2) {     // Low when Open
                [AppDelegate setCashDrawerOpenActiveHigh:NO];
            }
            
            alertView.delegate = nil;
            
            //
            customVc = [[CustomViewController alloc]init];
            
            
            //update printer port
            printer.model = _modelName;
            printer.macAddress = _macAddress;
            printer.portName = _portName;
            printer.modifiedUser = [Utility modifiedUser];
            printer.modifiedDate = [Utility currentDateTime];
            
            printerPort = _portName;
            

            
            customVc.homeModel = [[HomeModel alloc]init];
            customVc.homeModel.delegate = self;
            [customVc.homeModel updateItems:dbPrinter withData:printer actionScreen:@"update printer in search port screen"];
   
            selectPrinter = 1;
            [self performSegueWithIdentifier:@"segUnwindToSetUpPrinter" sender:self];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == AlertViewIndexRefreshPort)
    {
        if (buttonIndex == alertView.cancelButtonIndex) {
            alertView.delegate = nil;
            
//            [self.navigationController popViewControllerAnimated:YES];
            [self performSegueWithIdentifier:@"segUnwindToSettingPrinter" sender:self];
//            [self performSegueWithIdentifier:@"segUnwindToReceipt" sender:self];
        }
        else if (buttonIndex == 5) {     // Manual
            UIAlertView *nestAlertView = [[UIAlertView alloc] initWithTitle:@"Please enter the port name." message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            
            nestAlertView.tag            = AlertViewIndexPortName;
            nestAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            
            [nestAlertView textFieldAtIndex:0].text = [AppDelegate getPortName];
            
            [nestAlertView show];
        }
        else
        {
            self.blind = YES;
            
            [_cellArray removeAllObjects];
            
            _selectedIndexPath = nil;
            
            NSArray *portInfoArray;
            
            switch (buttonIndex) {
                default :
//              case 1  :     // LAN
                    portInfoArray = [SMPort searchPrinter:@"TCP:"];
                    break;
                case 2  :     // Bluetooth
                    portInfoArray = [SMPort searchPrinter:@"BT:"];
                    break;
                case 3  :     // Bluetooth Low Energy
                    portInfoArray = [SMPort searchPrinter:@"BLE:"];
                    break;
                case 4  :     // All
                    portInfoArray = [SMPort searchPrinter];
                    break;
            }
            
            NSString *portName   = [AppDelegate getPortName];
            NSString *modelName  = [AppDelegate getModelName];
            NSString *macAddress = [AppDelegate getMacAddress];
            
            int row = 0;
            
            for (PortInfo *portInfo in portInfoArray) {
                [_cellArray addObject:@[portInfo.portName, portInfo.modelName, portInfo.macAddress]];
                
                if ([portInfo.portName   isEqualToString:portName]   == YES &&
                    [portInfo.modelName  isEqualToString:modelName]  == YES &&
                    [portInfo.macAddress isEqualToString:macAddress] == YES) {
                    _selectedIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
                }
                
                row++;
            }
            
            [_tableView reloadData];
            
            self.blind = NO;
        }
    }
}

- (IBAction)goBack:(id)sender
{
//    [self.navigationController popViewControllerAnimated:YES];
    selectPrinter = 0;
    [self performSegueWithIdentifier:@"segUnwindToSetUpPrinter" sender:self];
//    [self performSegueWithIdentifier:@"segUnwindToReceipt" sender:self];
    
}

-(void)itemsUpdated
{
    
}

- (IBAction)reloadPort:(id)sender
{
    [self refreshPortInfo];
}
@end
