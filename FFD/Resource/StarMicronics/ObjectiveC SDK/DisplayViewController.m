//
//  DisplayViewController.m
//  ObjectiveC SDK
//
//  Created by Yuji on 2016/**/**.
//  Copyright © 2016年 Star Micronics. All rights reserved.
//

#import "DisplayViewController.h"

#import "AppDelegate.h"

#import "DisplayCommunication.h"

#import "DisplayFunctions.h"

@interface DisplayViewController ()

@property (nonatomic) NSIndexPath *selectedIndexPath;

@property (nonatomic) SCDCBInternationalType internationalType;
@property (nonatomic) SCDCBCodePageType      codePageType;

@end

@implementation DisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _selectedIndexPath = nil;
    
    _internationalType = SCDCBInternationalTypeUSA;
    _codePageType      = SCDCBCodePageTypeCP437;
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
        return 9;
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
                default : cell.textLabel.text = @"Check Status";                  break;     // 0
                case 1  : cell.textLabel.text = @"Text";                          break;
                case 2  : cell.textLabel.text = @"Graphic";                       break;
                case 3  : cell.textLabel.text = @"Turn On / Off";                 break;
                case 4  : cell.textLabel.text = @"Cursor";                        break;
                case 5  : cell.textLabel.text = @"Contrast";                      break;
                case 6  : cell.textLabel.text = @"Character Set (International)"; break;
                case 7  : cell.textLabel.text = @"Character Set (Code Page)";     break;
                case 8  : cell.textLabel.text = @"User Defined Character";        break;
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
        title = @"Contents";
    }
    else {
        title = @"Like a StarIoExtManager";
    }
    
    return title;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _selectedIndexPath = indexPath;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            self.blind = YES;
            
            SMPort *port = nil;
            
            @try {
                port = [SMPort getPort:[AppDelegate getPortName] :[AppDelegate getPortSettings] :10000];     // 10000mS!!!
                
                if (port != nil) {
                    [DisplayCommunication requestStatus:port completionHandler:^(BOOL result, NSString *title, NSString *message, BOOL connect) {
                        if (result == YES) {
                            if (connect == YES) {
                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Check Status" message:@"Display Connect." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                
                                [alertView show];
                            }
                            else {
                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Check Status" message:@"Display Disconnect." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                
                                [alertView show];
                            }
                        }
                        else {
//                          UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"Display Impossible." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
            UIAlertView *alertView;
            
            switch (indexPath.row) {
                default :
//              case 1  :
                    alertView = [[UIAlertView alloc] initWithTitle:@"Select Text"
                                                           message:@""
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                                 otherButtonTitles:@"Pattern 1", @"Pattern 2", @"Pattern 3", @"Pattern 4", @"Pattern 5", @"Pattern 6", nil];
                    break;
                case 2 :
                    alertView = [[UIAlertView alloc] initWithTitle:@"Select Graphic"
                                                           message:@""
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                                 otherButtonTitles:@"Pattern 1", @"Pattern 2", @"Pattern 3", @"Pattern 4", nil];
                    break;
                case 3 :
                    alertView = [[UIAlertView alloc] initWithTitle:@"Select Turn On / Off"
                                                           message:@""
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                                 otherButtonTitles:@"Turn On", @"Turn Off", nil];
                    break;
                case 4 :
                    alertView = [[UIAlertView alloc] initWithTitle:@"Select Cursor"
                                                           message:@""
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                                 otherButtonTitles:@"Off", @"Blink", @"On", nil];
                    break;
                case 5 :
                    alertView = [[UIAlertView alloc] initWithTitle:@"Select Contrast"
                                                           message:@""
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                                 otherButtonTitles:@"Contrast -3", @"Contrast -2", @"Contrast -1", @"Default", @"Contrast +1", @"Contrast +2", @"Contrast +3", nil];
                    break;
                case 6 :
                    alertView = [[UIAlertView alloc] initWithTitle:@"Select Character Set (International)"
                                                           message:@""
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                                 otherButtonTitles:@"USA",   @"France", @"Germany", @"UK",        @"Denmark", @"Sweden",        @"Italy",
                                                                   @"Spain", @"Japan",  @"Norway",  @"Denmark 2", @"Spain 2", @"Latin America", @"Korea",
                                                                   nil];
                    break;
                case 7 :
                    alertView = [[UIAlertView alloc] initWithTitle:@"Select Character Set (Code Page)"
                                                           message:@""
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                                 otherButtonTitles:@"Code Page 437",       @"Katakana",      @"Code Page 850", @"Code Page 860", @"Code Page 863", @"Code Page 865",
                                                                   @"Code Page 1252",      @"Code Page 866", @"Code Page 852", @"Code Page 858", @"Japanese",      @"Simplified Chinese",
                                                                   @"Traditional Chinese", @"Hangul",
                                                                   nil];
                    break;
                case 8 :
                    alertView = [[UIAlertView alloc] initWithTitle:@"Select User Defined Character"
                                                           message:@""
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                                 otherButtonTitles:@"Set", @"Reset", nil];
                    break;
            }
            
            [alertView show];
        }
    }
    else {
        [AppDelegate setSelectedIndex:indexPath.row];
        
        [self performSegueWithIdentifier:@"PushDisplayExtViewController" sender:nil];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        NSMutableData *commands = [[NSMutableData alloc] init];
        
        switch (_selectedIndexPath.row) {
            default :
//          case 1  :     // Text
                [commands appendData:[DisplayFunctions createClearScreen]];
                
                [commands appendData:[DisplayFunctions createCharacterSet:_internationalType codePageType:_codePageType]];
                
                [commands appendData:[DisplayFunctions createTextPattern:(int) (buttonIndex - 1)]];
                break;
            case 2 :     // Graphic
                [commands appendData:[DisplayFunctions createClearScreen]];
                
                [commands appendData:[DisplayFunctions createGraphicPattern:(int) (buttonIndex - 1)]];
                break;
            case 3 :     // Turn On / Off
//              [commands appendData:[DisplayFunctions createClearScreen]];
                
                switch (buttonIndex - 1) {
                    default : [commands appendData:[DisplayFunctions createTurnOn:YES]]; break;     // 0
                    case 1  : [commands appendData:[DisplayFunctions createTurnOn:NO]];  break;
                }
                
                break;
            case 4 :     // Cursor
                [commands appendData:[DisplayFunctions createClearScreen]];
                
                [commands appendData:[DisplayFunctions createCursorMode:buttonIndex - 1]];
                break;
            case 5 :     // Contrast
//              [commands appendData:[DisplayFunctions createClearScreen]];
                
                [commands appendData:[DisplayFunctions createContrastMode:buttonIndex - 1]];
                break;
            case 6 :     // Character Set (International)
                _internationalType = buttonIndex - 1;
                
                [commands appendData:[DisplayFunctions createClearScreen]];
                
                [commands appendData:[DisplayFunctions createCharacterSet:_internationalType codePageType:_codePageType]];
                break;
            case 7 :     // Character Set (Code Page)
                _codePageType = buttonIndex - 1;
                
                [commands appendData:[DisplayFunctions createClearScreen]];
                
                [commands appendData:[DisplayFunctions createCharacterSet:_internationalType codePageType:_codePageType]];
                break;
            case 8 :     // User Defined Character
                [commands appendData:[DisplayFunctions createClearScreen]];
                
                switch (buttonIndex - 1) {
                    default : [commands appendData:[DisplayFunctions createUserDefinedCharacter:YES]]; break;     // 0
                    case 1  : [commands appendData:[DisplayFunctions createUserDefinedCharacter:NO]];  break;
                }
                
                break;
        }
        
        self.blind = YES;
        
        SMPort *port = nil;
        
        @try {
            port = [SMPort getPort:[AppDelegate getPortName] :[AppDelegate getPortSettings] :10000];     // 10000mS!!!
            
            if (port != nil) {
                [DisplayCommunication requestStatus:port completionHandler:^(BOOL result, NSString *title, NSString *message, BOOL connect) {
                    if (result == YES) {
                        if (connect == YES) {
                            [DisplayCommunication passThroughCommands:commands port:port completionHandler:^(BOOL result, NSString *title, NSString *message) {
                                if (result == NO) {
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                    
                                    [alertView show];
                                }
                            }];
                        }
                        else {
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"Display Disconnect." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            
                            [alertView show];
                        }
                    }
                    else {
//                      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"Display Impossible." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
}

@end
