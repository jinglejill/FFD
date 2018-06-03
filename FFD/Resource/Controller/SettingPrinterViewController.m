//
//  SettingPrinterViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 11/10/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SettingPrinterViewController.h"
#import "SearchPortViewController.h"
#import "Setting.h"
#import <StarIO/SMPort.h>
#import "AppDelegate.h"


@interface SettingPrinterViewController ()
{
    NSString *_printerPortKey;
    NSMutableArray *_statusCellArray;
    NSMutableArray *_firmwareInfoCellArray;
}
@end

@implementation SettingPrinterViewController
@synthesize txtPrinterPortKitchen;
@synthesize txtPrinterPortKitchen2;
@synthesize txtPrinterPortDrinks;
@synthesize txtPrinterPortCashier;
@synthesize settingGroup;

- (IBAction)unwindToSettingDetail
{
    [self performSegueWithIdentifier:@"segUnwindToSettingDetail" sender:self];
}

- (IBAction)unwindToSettingPrinter:(UIStoryboardSegue *)segue
{
    SearchPortViewController *vc = segue.sourceViewController;
    if([_printerPortKey isEqualToString:@"printerPortKitchen"])
    {
        txtPrinterPortKitchen.text = vc.printerPort;
        [txtPrinterPortKitchen resignFirstResponder];
    }
    else if([_printerPortKey isEqualToString:@"printerPortKitchen2"])
    {
        txtPrinterPortKitchen2.text = vc.printerPort;
        [txtPrinterPortKitchen2 resignFirstResponder];
    }
    else if([_printerPortKey isEqualToString:@"printerPortDrinks"])
    {
        txtPrinterPortDrinks.text = vc.printerPort;
        [txtPrinterPortDrinks resignFirstResponder];
    }
    else if([_printerPortKey isEqualToString:@"printerPortCashier"])
    {
        txtPrinterPortCashier.text = vc.printerPort;
        [txtPrinterPortCashier resignFirstResponder];
    }
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if([textField isEqual:txtPrinterPortKitchen])
    {
        _printerPortKey = @"printerPortKitchen";
    }
    else if([textField isEqual:txtPrinterPortKitchen2])
    {
        _printerPortKey = @"printerPortKitchen2";
    }
    else if([textField isEqual:txtPrinterPortDrinks])
    {
        _printerPortKey = @"printerPortDrinks";
    }
    else if([textField isEqual:txtPrinterPortCashier])
    {
        _printerPortKey = @"printerPortCashier";
    }

    [textField resignFirstResponder];
    [self performSegueWithIdentifier:@"PushSearchPortViewController" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"PushSearchPortViewController"])
    {
        SearchPortViewController *vc = segue.destinationViewController;
        vc.printerPortKey = _printerPortKey;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return NO;
}

-(void)loadView
{
    [super loadView];
    txtPrinterPortKitchen.delegate = self;
    txtPrinterPortKitchen2.delegate = self;
    txtPrinterPortDrinks.delegate = self;
    txtPrinterPortCashier.delegate = self;
    
    
    {
        Setting *setting = [Setting getSettingWithKeyName:@"printerPortKitchen"];
        txtPrinterPortKitchen.text = setting.value;
    }
    {
        Setting *setting = [Setting getSettingWithKeyName:@"printerPortKitchen2"];
        txtPrinterPortKitchen2.text = setting.value;
    }
    {
        Setting *setting = [Setting getSettingWithKeyName:@"printerPortDrinks"];
        txtPrinterPortDrinks.text = setting.value;
    }
    {
        Setting *setting = [Setting getSettingWithKeyName:@"printerPortCashier"];
        txtPrinterPortCashier.text = setting.value;
    }
    
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadingOverlayView];
}

-(void)checkPrinterStatus
{
    BOOL result = NO;
    SMPort *port = nil;
    
    
    //    NSArray *portList = @[@"TCP:192.168.100.21",@"TCP:192.168.100.22"];
    NSMutableArray *printerStatusList = [[NSMutableArray alloc]init];
    NSMutableArray *portList = [[NSMutableArray alloc]init];
    [portList addObject:txtPrinterPortKitchen.text];
    [portList addObject:txtPrinterPortKitchen2.text];
    [portList addObject:txtPrinterPortDrinks.text];
    [portList addObject:txtPrinterPortCashier.text];
    
    
    for(int i=0; i<4; i++)
    {
        NSString *strPortName = @"";
        if(![Utility isStringEmpty:portList[i]])
        {
            strPortName = [NSString stringWithFormat:@"TCP:%@",portList[i]];
        }
        else
        {
            [printerStatusList addObject:@""];
            continue;
        }
        @try {
            while (YES) {
                //                port = [SMPort getPort:[AppDelegate getPortName] :[AppDelegate getPortSettings] :10000];     // 10000mS!!!
                port = [SMPort getPort:portList[i] :[AppDelegate getPortSettings] :10000];     // 10000mS!!!
                if (port == nil) {
                    i = 4;
                    [printerStatusList removeAllObjects];
                    break;
                }
                
                StarPrinterStatus_2 printerStatus;
                
                [port getParsedStatus:&printerStatus :2];
                
                if (printerStatus.offline == SM_TRUE) {
                    [_statusCellArray addObject:@[@"Online", @"Offline", [UIColor redColor]]];
                    [printerStatusList addObject:@""];
                }
                else {
                    [_statusCellArray addObject:@[@"Online", @"Online",  [UIColor blueColor]]];
                    [printerStatusList addObject:@"Online"];
                }
                
                if (printerStatus.offline == SM_TRUE) {
                    [_firmwareInfoCellArray addObject:@[@"Unable to get F/W info. from an error.", @"", [UIColor redColor]]];
                    
                    result = YES;
                    break;
                }
                else {
                    NSDictionary *firmwareInformation = [port getFirmwareInformation];
                    
                    if (firmwareInformation == nil) {
                        break;
                    }
                    
                    [_firmwareInfoCellArray addObject:@[@"Model Name",       [firmwareInformation objectForKey:@"ModelName"],       [UIColor blueColor]]];
                    
                    [_firmwareInfoCellArray addObject:@[@"Firmware Version", [firmwareInformation objectForKey:@"FirmwareVersion"], [UIColor blueColor]]];
                    
                    result = YES;
                    break;
                }
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
    }
    
    
    if (result == NO) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Fail to Open Port" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
    }
    [self removeOverlayViews];
}

@end
