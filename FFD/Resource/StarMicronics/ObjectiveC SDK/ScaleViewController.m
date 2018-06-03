//
//  ScaleViewController.m
//  ObjectiveC SDK
//
//  Created by Yuji on 2016/**/**.
//  Copyright © 2016年 Star Micronics. All rights reserved.
//

#import "ScaleViewController.h"

#import "AppDelegate.h"

#import "ScaleCommunication.h"

#import "ScaleFunctions.h"

@interface ScaleViewController ()

@end

@implementation ScaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if (section == 0) {
        return 4;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    static NSString *CellIdentifier = @"UITableViewCellStyleValue1";
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    if (cell != nil) {
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                default : cell.textLabel.text = @"Check Status";     break;     // 0
                case 1  : cell.textLabel.text = @"Displayed Weight"; break;
                case 2  : cell.textLabel.text = @"Zero Clear";       break;
                case 3  : cell.textLabel.text = @"Unit Change";      break;
            }
        }
        else {
            cell.textLabel.text = @"Sample";
        }
        
        cell.detailTextLabel.text = @"";
        
        cell.      textLabel.textColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = @"";
    
    if (section == 0) {
        return @"Contents";
    }
    else {
        title = @"Like a StarIoExtManager";
    }
    
    return title;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        self.blind = YES;
        
        SMPort *port = nil;
        
        @try {
            port = [SMPort getPort:[AppDelegate getPortName] :[AppDelegate getPortSettings] :10000];     // 10000mS!!!
            
            if (port != nil) {
                [ScaleCommunication requestStatus:port completionHandler:^(BOOL result, NSString *title, NSString *message, BOOL connect) {
                    if (result == YES) {
                        if (connect == YES) {
                            if (indexPath.row == 0) {
                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Check Status" message:@"Scale Connect." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                
                                [alertView show];
                            }
                            else if (indexPath.row == 1) {
                                IStarIoExtDisplayedWeightFunction *displayedWeightFunction = [ScaleFunctions createDisplayedWeightFunction];
                                
                                [ScaleCommunication passThroughFunction:displayedWeightFunction port:port completionHandler:^(BOOL result, NSString *title, NSString *message) {
                                    if (result == YES) {
                                        UIAlertView *alertView;
                                        
                                        switch (displayedWeightFunction.status) {
                                            default                                 :
//                                          case StarIoExtDisplayedWeightStatusZero :
                                                alertView = [[UIAlertView alloc] initWithTitle:@"Success [Zero]"
                                                                                       message:displayedWeightFunction.weight
                                                                                      delegate:nil
                                                                             cancelButtonTitle:@"OK"
                                                                             otherButtonTitles:nil];
                                                break;
                                            case StarIoExtDisplayedWeightStatusNotInMotion :
                                                alertView = [[UIAlertView alloc] initWithTitle:@"Success [Not in motion]"
                                                                                       message:displayedWeightFunction.weight
                                                                                      delegate:nil
                                                                             cancelButtonTitle:@"OK"
                                                                             otherButtonTitles:nil];
                                                break;
                                            case StarIoExtDisplayedWeightStatusMotion :
                                                alertView = [[UIAlertView alloc] initWithTitle:@"Success [Motion]"
                                                                                       message:displayedWeightFunction.weight
                                                                                      delegate:nil
                                                                             cancelButtonTitle:@"OK"
                                                                             otherButtonTitles:nil];
                                                break;
                                        }
                                        
                                        [alertView show];
                                    }
                                    else {     // Because the scale doesn't sometimes react.
                                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                        
                                        [alertView show];
                                    }
                                }];
                            }
                            else if (indexPath.row == 2) {
                                NSData *commands = [ScaleFunctions createZeroClear];
                                
                                [ScaleCommunication passThroughCommands:commands port:port completionHandler:^(BOOL result, NSString *title, NSString *message) {
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                    
                                    [alertView show];
                                }];
                            }
                            else {
                                NSData *commands = [ScaleFunctions createUnitChange];
                                
                                [ScaleCommunication passThroughCommands:commands port:port completionHandler:^(BOOL result, NSString *title, NSString *message) {
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                    
                                    [alertView show];
                                }];
                            }
                        }
                        else {
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"Scale Disconnect." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            
                            [alertView show];
                        }
                    }
                    else {
//                      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"Scale Impossible."   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"Printer Impossible." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        
                        [alertView show];
                    }
                }];
            }
            else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Fail to Open Port" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alertView show];
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
        
        self.blind = NO;
    }
    else {
        [AppDelegate setSelectedIndex:indexPath.row];
        
        [self performSegueWithIdentifier:@"PushScaleExtViewController" sender:nil];
    }
}

@end
