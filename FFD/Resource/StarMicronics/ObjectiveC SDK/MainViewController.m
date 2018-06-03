//
//  MainViewController.m
//  ObjectiveC SDK
//
//  Created by Yuji on 2015/**/**.
//  Copyright (c) 2015年 Star Micronics. All rights reserved.
//

#import "MainViewController.h"

#import "AppDelegate.h"

#import "ModelCapability.h"

#import "Communication.h"

typedef NS_ENUM(NSInteger, SectionIndex) {
    SectionIndexDevice = 0,
    SectionIndexPrinter,
    SectionIndexCashDrawer,
    SectionIndexBarcodeReader,
    SectionIndexDisplay,
    SectionIndexScale,
    SectionIndexCombination,
    SectionIndexApi,
    SectionIndexAllReceipts,
    SectionIndexDeviceStatus,
    SectionIndexAppendixBluetooth
};

typedef NS_ENUM(NSInteger, AlertViewIndex) {
    AlertViewIndexLanguage = 0,
    AlertViewIndexLanguageFixedPaperSize,
    AlertViewIndexPaperSize,
    AlertViewIndexConfirm
};

@interface MainViewController ()

@property (nonatomic) NSIndexPath *selectedIndexPath;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *title = @"StarPRNT Objective-C SDK";
    
    NSString *version = [NSString stringWithFormat:@"Ver.%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %@", title, version];
    
    _selectedIndexPath = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_tableView reloadData];
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
    
//  return SectionIndexDevice            + 1;
//  return SectionIndexPrinter           + 1;
//  return SectionIndexCashDrawer        + 1;
//  return SectionIndexBarcodeReader     + 1;
//  return SectionIndexDisplay           + 1;
//  return SectionIndexScale             + 1;
//  return SectionIndexCombination       + 1;
//  return SectionIndexApi               + 1;
//  return SectionIndexAllReceipts       + 1;
//  return SectionIndexDeviceStatus      + 1;
    return SectionIndexAppendixBluetooth + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if (section != SectionIndexAppendixBluetooth) {
        return 1;
    }
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if (indexPath.section == SectionIndexDevice) {
        if ([[AppDelegate getModelName] isEqualToString:@""]) {
            static NSString *CellIdentifier = @"UITableViewCellStyleValue1";
            
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            }
            
            if (cell != nil) {
                cell.backgroundColor = [UIColor colorWithRed:0.8 green:0.9 blue:1.0 alpha:1.0];
                
                cell.      textLabel.text = @"Unselected State";
                cell.detailTextLabel.text = @"";
                
                cell.      textLabel.textColor = [UIColor redColor];
                cell.detailTextLabel.textColor = [UIColor redColor];
                
                [UIView beginAnimations:nil context:nil];
                
                cell.      textLabel.alpha = 0.0;
                cell.detailTextLabel.alpha = 0.0;
                
                [UIView setAnimationDelay             :0.0];                            // 0mS!!!
                [UIView setAnimationDuration          :0.6];                            // 600mS!!!
                [UIView setAnimationRepeatCount       :UINT32_MAX];
                [UIView setAnimationRepeatAutoreverses:YES];
                [UIView setAnimationCurve             :UIViewAnimationCurveEaseIn];
                
                cell.      textLabel.alpha = 1.0;
                cell.detailTextLabel.alpha = 1.0;
                
                [UIView commitAnimations];
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                cell.userInteractionEnabled = YES;
            }
        }
        else {
            static NSString *CellIdentifier = @"UITableViewCellStyleSubtitle";
            
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            }
            
            if (cell != nil) {
                cell.backgroundColor = [UIColor colorWithRed:0.8 green:0.9 blue:1.0 alpha:1.0];
                
//              cell.      textLabel.text = [AppDelegate getPortName];
                cell.      textLabel.text = [AppDelegate getModelName];
//              cell.detailTextLabel.text = [AppDelegate getModelName];
                
                if ([[AppDelegate getMacAddress] isEqualToString:@""]) {
                    cell.detailTextLabel.text = [AppDelegate getPortName];
                }
                else {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%@)", [AppDelegate getPortName], [AppDelegate getMacAddress]];
                }
                
                cell.      textLabel.textColor = [UIColor blueColor];
                cell.detailTextLabel.textColor = [UIColor blueColor];
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
    }
    else {
        static NSString *CellIdentifier = @"UITableViewCellStyleValue1";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        
        if (cell != nil) {
            switch (indexPath.section) {
                default                       :
//              case SectionIndexPrinter      :
//              case SectionIndexCashDrawer   :
//              case SectionIndexDisplay      :
//              case SectionIndexScale        :
//              case SectionIndexDeviceStatus :
                    cell.backgroundColor = [UIColor whiteColor];
                    
                    cell.      textLabel.text = @"Sample";
                    cell.detailTextLabel.text = @"";
                    
                    cell.      textLabel.textColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
                    cell.detailTextLabel.textColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
                    break;
                case SectionIndexBarcodeReader :
                case SectionIndexCombination   :
                    cell.backgroundColor = [UIColor whiteColor];
                    
                    cell.      textLabel.text = @"StarIoExtManager Sample";
                    cell.detailTextLabel.text = @"";
                    
                    cell.      textLabel.textColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
                    cell.detailTextLabel.textColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
                    break;
                case SectionIndexApi :
                    cell.backgroundColor = [UIColor colorWithRed:1.0 green:0.9 blue:1.0 alpha:1.0];
                    
                    cell.      textLabel.text = @"Sample";
                    cell.detailTextLabel.text = @"";
                    
                    cell.      textLabel.textColor = [UIColor blueColor];
                    cell.detailTextLabel.textColor = [UIColor blueColor];
                    break;
                case SectionIndexAllReceipts :
                    cell.backgroundColor = [UIColor colorWithRed:0.8 green:1.0 blue:0.9 alpha:1.0];
                    
                    cell.      textLabel.text = @"Sample";
                    cell.detailTextLabel.text = @"";
                    
                    cell.      textLabel.textColor = [UIColor blueColor];
                    cell.detailTextLabel.textColor = [UIColor blueColor];
                    break;
                case SectionIndexAppendixBluetooth :
                    cell.backgroundColor = [UIColor whiteColor];
                    
                    if (indexPath.row == 0) {
                        cell.      textLabel.text = @"Pairing and Connect Bluetooth";
                        cell.detailTextLabel.text = @"";
                    }
                    else {
                        cell.      textLabel.text = @"Disconnect Bluetooth";
                        cell.detailTextLabel.text = @"";
                    }
                    
                    cell.      textLabel.textColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
                    cell.detailTextLabel.textColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
                    break;
            }
            
            BOOL userInteractionEnabled = YES;
            
            if ([[AppDelegate getModelName] isEqualToString:@""]) {
                userInteractionEnabled = NO;
            }
            
            StarIoExtEmulation emulation = [AppDelegate getEmulation];
            
            if (emulation == StarIoExtEmulationStarLine    ||
                emulation == StarIoExtEmulationStarGraphic ||
                emulation == StarIoExtEmulationEscPos) {
                if (indexPath.section == SectionIndexBarcodeReader ||
                    indexPath.section == SectionIndexDisplay       ||
                    indexPath.section == SectionIndexScale         ||
                    indexPath.section == SectionIndexCombination) {
                    userInteractionEnabled = NO;
                }
            }
            
            if (emulation == StarIoExtEmulationEscPosMobile) {
                if (indexPath.section == SectionIndexCashDrawer    ||
                    indexPath.section == SectionIndexBarcodeReader ||
                    indexPath.section == SectionIndexDisplay       ||
                    indexPath.section == SectionIndexScale         ||
                    indexPath.section == SectionIndexCombination) {
                    userInteractionEnabled = NO;
                }
            }
            
            if (emulation == StarIoExtEmulationStarDotImpact) {
                if (indexPath.section == SectionIndexBarcodeReader ||
                    indexPath.section == SectionIndexDisplay       ||
                    indexPath.section == SectionIndexScale         ||
                    indexPath.section == SectionIndexCombination   ||
                    indexPath.section == SectionIndexAllReceipts) {
                    userInteractionEnabled = NO;
                }
            }
            
            if (indexPath.section == SectionIndexAppendixBluetooth) {
                if (indexPath.row == 1) {     // Only Disconnect Bluetooth
                    if ([[AppDelegate getPortName] hasPrefix:@"BT:"] == NO) {
                        userInteractionEnabled = NO;
                    }
                }
            }
            
            if (userInteractionEnabled == YES) {
                cell.      textLabel.alpha = 1.0;
                cell.detailTextLabel.alpha = 1.0;
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                cell.userInteractionEnabled = YES;
            }
            else {
                cell.      textLabel.alpha = 0.3;
                cell.detailTextLabel.alpha = 0.3;
                
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                cell.userInteractionEnabled = NO;
            }
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = @"";
    
    switch (section) {
        default                 :
//      case SectionIndexDevice :
            title = @"Destination Device";
            break;
        case SectionIndexPrinter :
            title = @"Printer";
            break;
        case SectionIndexCashDrawer :
            title = @"Cash Drawer";
            break;
        case SectionIndexBarcodeReader :
            title = @"Barcode Reader (for mPOP)";
            break;
        case SectionIndexDisplay :
            title = @"Display (for mPOP)";
            break;
        case SectionIndexScale :
            title = @"Scale (for mPOP)";
            break;
        case SectionIndexCombination :
            title = @"Combination (for mPOP)";
            break;
        case SectionIndexApi :
            title = @"API";
            break;
        case SectionIndexAllReceipts :
            title = @"AllReceipts";
            break;
        case SectionIndexDeviceStatus :
            title = @"Device Status";
            break;
        case SectionIndexAppendixBluetooth :
            title = @"Appendix (Bluetooth)";
            break;
    }
    
    return title;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _selectedIndexPath = indexPath;
    
    UIAlertView *alertView = nil;
    
    switch (_selectedIndexPath.section) {
        default                 :
//      case SectionIndexDevice :
            [self performSegueWithIdentifier:@"PushSearchPortViewController" sender:nil];
            break;
        case SectionIndexPrinter :
            alertView = [[UIAlertView alloc] initWithTitle:@"Select language."
                                                   message:@""
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"English", @"Japanese", @"French", @"Portuguese", @"Spanish", @"German", @"Russian", @"Simplified Chinese", @"Traditional Chinese", nil];
            
            if ([AppDelegate getEmulation] == StarIoExtEmulationEscPos ||
                [AppDelegate getEmulation] == StarIoExtEmulationStarDotImpact) {
                alertView.tag = AlertViewIndexLanguageFixedPaperSize;
            }
            else {
                alertView.tag = AlertViewIndexLanguage;
            }
            
            [alertView show];
            break;
        case SectionIndexCashDrawer :
            [self performSegueWithIdentifier:@"PushCashDrawerViewController" sender:nil];
            break;
        case SectionIndexBarcodeReader :
        case SectionIndexDisplay       :
        case SectionIndexScale         :
        case SectionIndexCombination   :
            alertView = [[UIAlertView alloc] initWithTitle:@"This menu is for mPOP."
                                                   message:@""
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"Continue", nil];
            
            alertView.tag = AlertViewIndexConfirm;
            
            [alertView show];
            break;
        case SectionIndexApi :
            if ([AppDelegate getEmulation] == StarIoExtEmulationEscPos) {
                [AppDelegate setSelectedPaperSize:PaperSizeIndexEscPosThreeInch];
                
                [self performSegueWithIdentifier:@"PushApiViewController" sender:nil];
            }
            else if ([AppDelegate getEmulation] == StarIoExtEmulationStarDotImpact) {
                [AppDelegate setSelectedPaperSize:PaperSizeIndexDotImpactThreeInch];
                
                [self performSegueWithIdentifier:@"PushApiViewController" sender:nil];
            }
            else {
                alertView = [[UIAlertView alloc] initWithTitle:@"Select paper size."
                                                       message:@""
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:@"2\" (384dots)", @"3\" (576dots)", @"4\" (832dots)", nil];
                
                alertView.tag = AlertViewIndexPaperSize;
                
                [alertView show];
            }
            
            break;
        case SectionIndexAllReceipts :
            alertView = [[UIAlertView alloc] initWithTitle:@"Select language."
                                                   message:@""
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
//                                       otherButtonTitles:@"English", @"Japanese", @"French", @"Portuguese", @"Spanish", @"German", @"Russian", @"Simplified Chinese", @"Traditional Chinese", nil];
                                         otherButtonTitles:@"English", @"Japanese", @"French", @"Portuguese", @"Spanish", @"German",                                                            nil];
            
            if ([AppDelegate getEmulation] == StarIoExtEmulationEscPos) {
                alertView.tag = AlertViewIndexLanguageFixedPaperSize;
            }
            else {
                alertView.tag = AlertViewIndexLanguage;
            }
            
            [alertView show];
            break;
        case SectionIndexDeviceStatus :
            [self performSegueWithIdentifier:@"PushDeviceStatusViewController" sender:nil];
            break;
        case SectionIndexAppendixBluetooth :
            if (_selectedIndexPath.row == 0) {
                [Communication connectBluetooth:^(BOOL result, NSString *title, NSString *message) {
                    if (title   != nil ||
                        message != nil) {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        
                        [alertView show];
                    }
                }];
            }
            else {
                self.blind = YES;
                
                NSString *modelName    = [AppDelegate getModelName];
                NSString *portName     = [AppDelegate getPortName];
                NSString *portSettings = [AppDelegate getPortSettings];
                
                [Communication disconnectBluetooth:modelName portName:portName portSettings:portSettings timeout:10000 completionHandler:^(BOOL result, NSString *title, NSString *message) {     // 10000mS!!!
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    
                    [alertView show];
                }];
                
                self.blind = NO;
            }
            
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        UIAlertView *nestAlertView = nil;
        
        switch (alertView.tag) {
            default                     :
//          case AlertViewIndexLanguage :
                [AppDelegate setSelectedLanguage:buttonIndex - 1];     // Same!!!
                
                nestAlertView = [[UIAlertView alloc] initWithTitle:@"Select paper size."
                                                           message:@""
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                                 otherButtonTitles:@"2\" (384dots)", @"3\" (576dots)", @"4\" (832dots)", nil];
                
                nestAlertView.tag = AlertViewIndexPaperSize;
                
                [nestAlertView show];
                break;
            case AlertViewIndexLanguageFixedPaperSize :
                [AppDelegate setSelectedLanguage:buttonIndex - 1];     // Same!!!
                
                switch (_selectedIndexPath.section) {
                    default                  :
//                  case SectionIndexPrinter :
                        if ([AppDelegate getEmulation] == StarIoExtEmulationEscPos) {
                            [AppDelegate setSelectedPaperSize:PaperSizeIndexEscPosThreeInch];
                        }
                        else {
                            [AppDelegate setSelectedPaperSize:PaperSizeIndexDotImpactThreeInch];
                        }
                        
                        [self performSegueWithIdentifier:@"PushPrinterViewController"     sender:nil];
                        break;
                    case SectionIndexCombination :
                        [AppDelegate setSelectedPaperSize:PaperSizeIndexTwoInch];
                        
                        [self performSegueWithIdentifier:@"PushCombinationViewController" sender:nil];
                        break;
                    case SectionIndexAllReceipts :
                        [AppDelegate setSelectedPaperSize:PaperSizeIndexEscPosThreeInch];
                        
                        [self performSegueWithIdentifier:@"PushAllReceiptsViewController" sender:nil];
                        break;
                }
                
                break;
            case AlertViewIndexPaperSize :
                switch (buttonIndex - 1) {
                    default :
//                  case 0 :
                        [AppDelegate setSelectedPaperSize:PaperSizeIndexTwoInch];
                        break;
                    case 1 :
                        [AppDelegate setSelectedPaperSize:PaperSizeIndexThreeInch];
                        break;
                    case 2 :
                        [AppDelegate setSelectedPaperSize:PaperSizeIndexFourInch];
                        break;
                }
                
                switch (_selectedIndexPath.section) {
                    default                  :
//                  case SectionIndexPrinter :
                        [self performSegueWithIdentifier:@"PushPrinterViewController"     sender:nil];
                        break;
                    case SectionIndexApi :
                        [self performSegueWithIdentifier:@"PushApiViewController"         sender:nil];
                        break;
                    case SectionIndexAllReceipts :
                        [self performSegueWithIdentifier:@"PushAllReceiptsViewController" sender:nil];
                        break;
                }
                
                break;
            case AlertViewIndexConfirm :
                switch (_selectedIndexPath.section) {
                    default                        :
//                  case SectionIndexBarcodeReader :
                        [self performSegueWithIdentifier:@"PushBarcodeReaderExtViewController" sender:nil];
                        break;
                    case SectionIndexDisplay :
                        [self performSegueWithIdentifier:@"PushDisplayViewController"          sender:nil];
                        break;
                    case SectionIndexScale :
                        [self performSegueWithIdentifier:@"PushScaleViewController"            sender:nil];
                        break;
                    case SectionIndexCombination :
                        nestAlertView = [[UIAlertView alloc] initWithTitle:@"Select language."
                                                                   message:@""
                                                                  delegate:self
                                                         cancelButtonTitle:@"Cancel"
                                                         otherButtonTitles:@"English", @"Japanese", @"French", @"Portuguese", @"Spanish", @"German", @"Russian", @"Simplified Chinese", @"Traditional Chinese", nil];
                        
                        nestAlertView.tag = AlertViewIndexLanguageFixedPaperSize;
                        
                        [nestAlertView show];
                        break;
                }
                
                break;
        }
    }
}

@end
