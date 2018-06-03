//
//  DisplayExtViewController.m
//  ObjectiveC SDK
//
//  Created by Yuji on 2016/**/**.
//  Copyright © 2016年 Star Micronics. All rights reserved.
//

#import "DisplayExtViewController.h"

#import "AppDelegate.h"

#import "DisplayCommunication.h"

#import "DisplayFunctions.h"

typedef NS_ENUM(NSInteger, DisplayStatus) {
    DisplayStatusInvalid = 0,
    DisplayStatusImpossible,
    DisplayStatusConnect,
    DisplayStatusDisconnect
};

@interface DisplayExtViewController ()

@property (nonatomic) SMPort *port;

@property (nonatomic) DisplayStatus displayStatus;

@property (nonatomic) NSRecursiveLock *lock;

@property (nonatomic) dispatch_group_t dispatchGroup;

@property (nonatomic) dispatch_semaphore_t terminateTaskSemaphore;

@property (nonatomic) NSIndexPath *selectedIndexPath;

@property (nonatomic) SCDCBInternationalType internationalType;
@property (nonatomic) SCDCBCodePageType      codePageType;

- (void)applicationWillResignActive;
- (void)applicationDidBecomeActive;

- (void)refreshDisplay;

- (BOOL)connect;

- (BOOL)disconnect;

- (void)watchDisplayTask;

- (void)beginAnimationCommantLabel;
- (void)endAnimationCommantLabel;

@end

@implementation DisplayExtViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _commentLabel.text = @"";
    
    _commentLabel.adjustsFontSizeToFitWidth = YES;
    
    [self appendRefreshButton:@selector(refreshDisplay)];
    
    _port = nil;
    
    _displayStatus = DisplayStatusInvalid;
    
    _lock = [NSRecursiveLock new];
    
    _dispatchGroup = dispatch_group_create();
    
    _terminateTaskSemaphore = dispatch_semaphore_create(1);
    
    _selectedIndexPath = nil;
    
    _internationalType = SCDCBInternationalTypeUSA;
    _codePageType      = SCDCBCodePageTypeCP437;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive)  name:UIApplicationDidBecomeActiveNotification  object:nil];
    
    [self refreshDisplay];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self disconnect];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification  object:nil];
}

- (void)applicationDidBecomeActive {
    [self beginAnimationCommantLabel];
    
    [self refreshDisplay];
}

- (void)applicationWillResignActive {
    [self disconnect];
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
    
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    static NSString *CellIdentifier = @"UITableViewCellStyleValue1";
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    if (cell != nil) {
        switch (indexPath.row) {
            default : cell.textLabel.text = @"Text";                   break;     // 0
            case 1  : cell.textLabel.text = @"Graphic";                break;
            case 2  : cell.textLabel.text = @"Turn On / Off";          break;
            case 3  : cell.textLabel.text = @"Cursor";                 break;
            case 4  : cell.textLabel.text = @"Contrast";               break;
            case 5  : cell.textLabel.text = @"Character Set";          break;
            case 6  : cell.textLabel.text = @"User Defined Character"; break;
        }
        
        cell.detailTextLabel.text = @"";
        
        cell.      textLabel.textColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Contents";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//  [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _selectedIndexPath = indexPath;
    
    [_pickerView reloadAllComponents];
    
    NSMutableData *commands = [[NSMutableData alloc] init];
    
    switch (indexPath.row) {
        default :
//      case 0  :     // Text
            [commands appendData:[DisplayFunctions createClearScreen]];
            
            [_pickerView selectRow:0 inComponent:0 animated:NO];
            
            [commands appendData:[DisplayFunctions createCharacterSet:_internationalType codePageType:_codePageType]];
            
            [commands appendData:[DisplayFunctions createTextPattern:0]];
            break;
        case 1 :     // Graphic
            [commands appendData:[DisplayFunctions createClearScreen]];
            
            [_pickerView selectRow:0 inComponent:0 animated:NO];
            
            [commands appendData:[DisplayFunctions createGraphicPattern:0]];
            break;
        case 2 :     // Turn On / Off
//          [commands appendData:[DisplayFunctions createClearScreen]];
            
            [_pickerView selectRow:0 inComponent:0 animated:NO];
            
            [commands appendData:[DisplayFunctions createTurnOn:YES]];
            break;
        case 3 :     // Cursor
            [commands appendData:[DisplayFunctions createClearScreen]];
            
            [_pickerView selectRow:SCDCBCursorModeOn inComponent:0 animated:NO];
            
            [commands appendData:[DisplayFunctions createCursorMode:SCDCBCursorModeOn]];
            break;
        case 4 :     // Contrast
//          [commands appendData:[DisplayFunctions createClearScreen]];
            
            [_pickerView selectRow:SCDCBContrastModeDefault inComponent:0 animated:NO];
            
            [commands appendData:[DisplayFunctions createContrastMode:SCDCBContrastModeDefault]];
            break;
        case 5 :     // Character Set
            [commands appendData:[DisplayFunctions createClearScreen]];
            
            [_pickerView selectRow:SCDCBInternationalTypeUSA inComponent:0 animated:NO];
            [_pickerView selectRow:SCDCBCodePageTypeCP437    inComponent:1 animated:NO];
            
            _internationalType = SCDCBInternationalTypeUSA;
            _codePageType      = SCDCBCodePageTypeCP437;
            
            [commands appendData:[DisplayFunctions createCharacterSet:_internationalType codePageType:_codePageType]];
            break;
        case 6 :     // User Defined Character
            [commands appendData:[DisplayFunctions createClearScreen]];
            
            [_pickerView selectRow:0 inComponent:0 animated:NO];
            
            [commands appendData:[DisplayFunctions createUserDefinedCharacter:YES]];
            break;
    }
    
    self.blind = YES;
    
    [_lock lock];
    
    if (_displayStatus == DisplayStatusConnect) {
        [DisplayCommunication passThroughCommands:commands port:_port completionHandler:^(BOOL result, NSString *title, NSString *message) {
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
    
    [_lock unlock];
    
    self.blind = NO;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    NSInteger number;
    
    if (_selectedIndexPath == nil) {
        number = 0;
    }
    else {
        switch (_selectedIndexPath.row) {
            default : number = 1; break;     // Text
            case 1  : number = 1; break;     // Graphic
            case 2  : number = 1; break;     // Turn On / Off
            case 3  : number = 1; break;     // Cursor
            case 4  : number = 1; break;     // Contrast
            case 5  : number = 2; break;     // Character Set
            case 6  : number = 1; break;     // User Defined Character
        }
    }
    
    return number;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger number;
    
    if (_selectedIndexPath == nil) {
        number = 0;
    }
    else {
        switch (_selectedIndexPath.row) {
            default : number = 6;  break;     // Text
            case 1  : number = 4;  break;     // Graphic
            case 2  : number = 2;  break;     // Turn On / Off
            case 3  : number = 3;  break;     // Cursor
            case 4  : number = 7;  break;     // Contrast
            case 5  : number = 14; break;     // Character Set
            case 6  : number = 2;  break;     // User Defined Character
        }
    }
    
    return number;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = (id)view;
    
    if (! label) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
    }
    
    if (_selectedIndexPath == nil) {
        label.text = @"";
    }
    else {
        switch (_selectedIndexPath.row) {
            default :
//          case 0  :     // Text
                switch (row) {
                    default : label.text = @"Pattern 1"; break;     // 0
                    case 1  : label.text = @"Pattern 2"; break;
                    case 2  : label.text = @"Pattern 3"; break;
                    case 3  : label.text = @"Pattern 4"; break;
                    case 4  : label.text = @"Pattern 5"; break;
                    case 5  : label.text = @"Pattern 6"; break;
                }
                
                break;
            case 1 :     // Graphic
                switch (row) {
                    default : label.text = @"Pattern 1"; break;     // 0
                    case 1  : label.text = @"Pattern 2"; break;
                    case 2  : label.text = @"Pattern 3"; break;
                    case 3  : label.text = @"Pattern 4"; break;
                }
                
                break;
            case 2 :     // Turn On / Off
                switch (row) {
                    default : label.text = @"Turn On";  break;     // 0
                    case 1  : label.text = @"Turn Off"; break;
                }
                
                break;
            case 3 :     // Cursor
                switch (row) {
                    default : label.text = @"Off";   break;     // 0
                    case 1  : label.text = @"Blink"; break;
                    case 2  : label.text = @"On";    break;
                }
                
                break;
            case 4 :     // Contrast
                switch (row) {
                    case 0  : label.text = @"Contrast -3"; break;
                    case 1  : label.text = @"Contrast -2"; break;
                    case 2  : label.text = @"Contrast -1"; break;
                    default : label.text = @"Default";     break;     // 3
                    case 4  : label.text = @"Contrast +1"; break;
                    case 5  : label.text = @"Contrast +2"; break;
                    case 6  : label.text = @"Contrast +3"; break;
                }
                
                break;
            case 5 :     // Character Set
                switch (component) {
                    default :     // 0
                        switch (row) {
                            default : label.text = @"USA";           break;     // 0
                            case 1  : label.text = @"France";        break;
                            case 2  : label.text = @"Germany";       break;
                            case 3  : label.text = @"UK";            break;
                            case 4  : label.text = @"Denmark";       break;
                            case 5  : label.text = @"Sweden";        break;
                            case 6  : label.text = @"Italy";         break;
                            case 7  : label.text = @"Spain";         break;
                            case 8  : label.text = @"Japan";         break;
                            case 9  : label.text = @"Norway";        break;
                            case 10 : label.text = @"Denmark 2";     break;
                            case 11 : label.text = @"Spain 2";       break;
                            case 12 : label.text = @"Latin America"; break;
                            case 13 : label.text = @"Korea";         break;
                        }
                        
                        break;
                    case 1 :
                        switch (row) {
                            default : label.text = @"Code Page 437";       break;     // 0
                            case 1  : label.text = @"Katakana";            break;
                            case 2  : label.text = @"Code Page 850";       break;
                            case 3  : label.text = @"Code Page 860";       break;
                            case 4  : label.text = @"Code Page 863";       break;
                            case 5  : label.text = @"Code Page 865";       break;
                            case 6  : label.text = @"Code Page 1252";      break;
                            case 7  : label.text = @"Code Page 866";       break;
                            case 8  : label.text = @"Code Page 852";       break;
                            case 9  : label.text = @"Code Page 858";       break;
                            case 10 : label.text = @"Japanese";            break;
                            case 11 : label.text = @"Simplified Chinese";  break;
                            case 12 : label.text = @"Traditional Chinese"; break;
                            case 13 : label.text = @"Hangul";              break;
                        }
                        
                        break;
                }
                
                break;
            case 6 :     // User Defined Character
                switch (row) {
                    default : label.text = @"Set";   break;     // 0
                    case 1  : label.text = @"Reset"; break;
                }
                
                break;
        }
    }
    
    label.font                      = [UIFont systemFontOfSize:22.0];
    label.textAlignment             = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSData *commands = nil;
    
    switch (_selectedIndexPath.row) {
        default :
//      case 0  :     // Text
            commands = [DisplayFunctions createTextPattern:(int) row];
            break;
        case 1 :     // Graphic
            commands = [DisplayFunctions createGraphicPattern:(int) row];
            break;
        case 2 :     // Turn On / Off
            switch (row) {
                default : commands = [DisplayFunctions createTurnOn:YES]; break;     // 0
                case 1  : commands = [DisplayFunctions createTurnOn:NO];  break;
            }
            
            break;
        case 3 :     // Cursor
            commands = [DisplayFunctions createCursorMode:row];
            break;
        case 4 :     // Contrast
            commands = [DisplayFunctions createContrastMode:row];
            break;
        case 5 :     // Character Set
            _internationalType = [_pickerView selectedRowInComponent:0];
            _codePageType      = [_pickerView selectedRowInComponent:1];
            
            commands = [DisplayFunctions createCharacterSet:_internationalType codePageType:_codePageType];
            break;
        case 6 :     // User Defined Character
            switch (row) {
                default : commands = [DisplayFunctions createUserDefinedCharacter:YES]; break;     // 0
                case 1  : commands = [DisplayFunctions createUserDefinedCharacter:NO];  break;
            }
            
            break;
    }
    
    self.blind = YES;
    
    [_lock lock];
    
    if (_displayStatus == DisplayStatusConnect) {
        [DisplayCommunication passThroughCommands:commands port:_port completionHandler:^(BOOL result, NSString *title, NSString *message) {
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
    
    [_lock unlock];
    
    self.blind = NO;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 160;
}

- (void)refreshDisplay {
    self.blind = YES;
    
    [self disconnect];
    
    if ([self connect] == NO) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Fail to Open Port." message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
    }
    
    self.blind = NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    _commentLabel.text = @"Check the device. (Power and Bluetooth pairing)\nThen touch up the Refresh button.";
    
    _commentLabel.textColor = [UIColor redColor];
    
    [self beginAnimationCommantLabel];
    
    _commentLabel.hidden = NO;
}

- (BOOL)connect {
    BOOL result = YES;
    
    if (_port == nil) {
        result = NO;
        
        @try {
            _port = [SMPort getPort:[AppDelegate getPortName] :[AppDelegate getPortSettings] :10000];     // 10000mS!!!
            
            if (_port != nil) {
                StarPrinterStatus_2 status;
                
                [_port getParsedStatus:&status :2];
                
                dispatch_semaphore_wait(_terminateTaskSemaphore, DISPATCH_TIME_FOREVER);
                
                dispatch_group_async(_dispatchGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self watchDisplayTask];
                });
                
                result = YES;
            }
        }
        @catch (NSException *exc) {
            [SMPort releasePort:_port];
            
            _port = nil;
        }
    }
    
    return result;
}

- (BOOL)disconnect {
    BOOL result = YES;
    
    if (_port != nil) {
        result = NO;
        
        dispatch_semaphore_signal(_terminateTaskSemaphore);
        
        dispatch_group_wait(_dispatchGroup, DISPATCH_TIME_FOREVER);
        
        [SMPort releasePort:_port];
        
        _port = nil;
        
        _displayStatus = DisplayStatusInvalid;
        
        result = YES;
    }
    
    return result;
}

- (void)watchDisplayTask {
    while (YES) {
        @autoreleasepool {
//          BOOL portValid = NO;
            BOOL portValid = YES;
            
            if ([_lock tryLock]) {
                portValid = NO;
                
                if (_port != nil) {
                    if (_port.connected == YES) {
                        portValid = YES;
                    }
                }
                
                if (portValid == YES) {
                    [DisplayCommunication requestStatus:_port completionHandler:^(BOOL result, NSString *title, NSString *message, BOOL connect) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (result == YES) {
                                if (connect == YES) {
                                    if (_displayStatus != DisplayStatusConnect) {
                                        _displayStatus = DisplayStatusConnect;
                                        
//                                      _commentLabel.text = @"Accessory Connect Success.";
//
//                                      _commentLabel.textColor = [UIColor blueColor];
//
//                                      [self beginAnimationCommantLabel];
                                        
                                        _commentLabel.hidden = YES;
                                    }
                                }
                                else {
                                    if (_displayStatus != DisplayStatusDisconnect) {
                                        _displayStatus = DisplayStatusDisconnect;
                                        
                                        _commentLabel.text = @"Display Disconnect.";
                                        
                                        _commentLabel.textColor = [UIColor redColor];
                                        
                                        [self beginAnimationCommantLabel];
                                        
                                        _commentLabel.hidden = NO;
                                    }
                                }
                            }
                            else {
                                if (_displayStatus != DisplayStatusImpossible) {
                                    _displayStatus = DisplayStatusImpossible;
                                    
//                                  _commentLabel.text = @"Display Impossible.";
                                    _commentLabel.text = @"Printer Impossible.";
                                    
                                    _commentLabel.textColor = [UIColor redColor];
                                    
                                    [self beginAnimationCommantLabel];
                                    
                                    _commentLabel.hidden = NO;
                                }
                            }
                        });
                    }];
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (_displayStatus != DisplayStatusImpossible) {
                            _displayStatus = DisplayStatusImpossible;
                            
//                          _commentLabel.text = @"Display Impossible.";
                            _commentLabel.text = @"Printer Impossible.";
                            
                            _commentLabel.textColor = [UIColor redColor];
                            
                            [self beginAnimationCommantLabel];
                            
                            _commentLabel.hidden = NO;
                        }
                    });
                }
                
                [_lock unlock];
            }
            
            dispatch_time_t timeout;
            
            timeout = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);     // 1000mS!!!
            
            if (dispatch_semaphore_wait(_terminateTaskSemaphore, timeout) == 0) {
                dispatch_semaphore_signal(_terminateTaskSemaphore);
                break;
            }
        }
    }
}

- (void)beginAnimationCommantLabel {
    [UIView beginAnimations:nil context:nil];
    
    _commentLabel.alpha = 0.0;
    
    [UIView setAnimationDelay             :0.0];                            // 0mS!!!
    [UIView setAnimationDuration          :0.6];                            // 600mS!!!
    [UIView setAnimationRepeatCount       :UINT32_MAX];
    [UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationCurve             :UIViewAnimationCurveEaseIn];
    
    _commentLabel.alpha = 1.0;
    
    [UIView commitAnimations];
}

- (void)endAnimationCommantLabel {
    [_commentLabel.layer removeAllAnimations];
}

@end
