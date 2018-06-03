//
//  LaunchWithLogoViewController.m
//  Eventoree
//
//  Created by Thidaporn Kijkamjai on 8/30/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "LaunchWithLogoViewController.h"
#import "ChristmasConstants.h"
#import "KeychainWrapper.h"
#import "Utility.h"
#import "PushSync.h"
#import "Credentials.h"
#import "Device.h"
#import "Message.h"


extern NSArray *globalMessage;
@interface LaunchWithLogoViewController ()
{
//    HomeModel *self.homeModel;
    UIActivityIndicatorView *indicator;
    UIView *overlayView;
}
@end

@implementation LaunchWithLogoViewController
@synthesize progressBar;

- (void)presentAlertViewForPassword
{
    
    // 1
    BOOL hasPin = [[NSUserDefaults standardUserDefaults] boolForKey:PIN_SAVED];
    
    // 2
    if (hasPin)
    {
        [self downloadData];
    }
    else
    {
//        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Setup Credentials"
//                                                                       message:@""
//                                                                preferredStyle:UIAlertControllerStyleAlert];
//        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//            textField.placeholder = @"Name";
//            textField.textColor = [UIColor blueColor];
//            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//            textField.borderStyle = UITextBorderStyleRoundedRect;
//            textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
//            textField.delegate = self;
//            textField.tag = kTextFieldName;
//        }];
//        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//            textField.placeholder = @"Password";
//            textField.textColor = [UIColor blueColor];
//            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//            textField.borderStyle = UITextBorderStyleRoundedRect;
//            textField.secureTextEntry = YES;
//            textField.delegate = self;
//            textField.tag = kTextFieldPassword;
//        }];
//        
//        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault
//                                                              handler:^(UIAlertAction * action)
//                                                              {
//                                                                  [self credentialsValidated];
//                                                              }];
//        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
//                                                             handler:^(UIAlertAction * action)
//                                                             {
//                                                                 [self presentAlertViewForPassword];
//                                                             }];
//        
//        
//        [alertController addAction:defaultAction];
//        [alertController addAction:cancelAction];
//        
//        
//        [self presentViewController:alertController animated:YES completion:nil];
        
        
        
        

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Setup Credentials"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Done", nil];
        // 6
        alert.delegate = self;
        [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
        alert.tag = kAlertTypeSetup;
        UITextField *nameField = [alert textFieldAtIndex:0];
        nameField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        nameField.placeholder = @"Name"; // Replace the standard placeholder text with something more applicable
        nameField.delegate = self;
        nameField.tag = kTextFieldName;
        UITextField *passwordField = [alert textFieldAtIndex:1]; // Capture the Password text field since there are 2 fields
        passwordField.delegate = self;
        passwordField.tag = kTextFieldPassword;
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{

    if (alertView.tag == kAlertTypeSetup)
    {
        if (buttonIndex == 1)
        { // User selected "Done"
            [self credentialsValidated];
        }
        else
        { // User selected "Cancel"
            [self presentAlertViewForPassword];
        }
    }
}

#pragma mark - Text Field + Alert View Methods
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // 1
    switch (textField.tag) {
        case kTextFieldName: // 1st part of the Setup flow.
            NSLog(@"User entered name");
            if ([textField.text length] > 0)
            {
                [[NSUserDefaults standardUserDefaults] setValue:[textField.text uppercaseString] forKey:USERNAME];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            break;
        case kTextFieldPassword: // 2nd half of the Setup flow.
            NSLog(@"User entered PIN");
            if ([textField.text length] > 0)
            {
                [[NSUserDefaults standardUserDefaults] setValue:textField.text forKey:PASSWORD];
                [[NSUserDefaults standardUserDefaults] synchronize];
                            }
            break;
        default:
            break;
    }
}

// Helper method to congregate the Name and PIN fields for validation.
- (void)credentialsValidated
{
    [self loadingOverlayView];
    
    NSString *name = [[NSUserDefaults standardUserDefaults] stringForKey:USERNAME];
    NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:PASSWORD];
    
    Credentials *credentials = [[Credentials alloc]init];
    credentials.username = name;
    credentials.password = password;
    [self.homeModel updateItems:dbCredentials withData:credentials actionScreen:@"Validate credential"];
}

- (void)itemsUpdated:(NSString *)alertText//if error
{
    [self removeOverlayViews];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:alertText
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [self presentAlertViewForPassword];
                                    }];
    [alert addAction:defaultAction];
    dispatch_async(dispatch_get_main_queue(),^ {
        [self presentViewController:alert animated:YES completion:nil];
    } );
}

- (void)itemsUpdated//if not error
{
    if(self.homeModel.propCurrentDB == dbCredentials)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:PIN_SAVED];
        
        
        if([Utility dbName])
        {
            Device *device = [[Device alloc]init];
            device.deviceToken = [Utility deviceToken];
            [self.homeModel insertItems:dbDevice withData:device actionScreen:@"Add device in Launching screen"];
        }
    }
    
    [self removeOverlayViews];
    [self loadViewProcess];
}

- (void)loadView
{
    [super loadView];
    
    
    [self presentAlertViewForPassword];
}

- (void)loadViewProcess
{
    [self presentAlertViewForPassword];
}

- (void)downloadData
{
    NSMutableArray *arrItemMessage = [[NSMutableArray alloc] init];
    
    
    
    NSArray *jsonArrayMessage = @[@{@"EnumNo":@"0",@"EnumKey":@"skipMessage1",@"Message":@"-",@"ModifiedDate":@"2015-07-30 15:34:31"},@{@"EnumNo":@"1",@"EnumKey":@"incorrectPasscode",@"Message":@"Incorrect passcode",@"ModifiedDate":@"0000-00-00 00:00:00"},@{@"EnumNo":@"2",@"EnumKey":@"skipMessage2",@"Message":@"-",@"ModifiedDate":@"2015-07-30 15:34:48"},@{@"EnumNo":@"3",@"EnumKey":@"emailSubjectAdd",@"Message":@"Minimalist - your username and password",@"ModifiedDate":@"0000-00-00 00:00:00"},@{@"EnumNo":@"4",@"EnumKey":@"emailBodyAdd",@"Message":@"Your username is %@<br>Your password is %@",@"ModifiedDate":@"0000-00-00 00:00:00"},@{@"EnumNo":@"5",@"EnumKey":@"emailSubjectReset",@"Message":@"Minimalist - you request a new password",@"ModifiedDate":@"0000-00-00 00:00:00"},@{@"EnumNo":@"6",@"EnumKey":@"emailBodyReset",@"Message":@"Your username is %@<br>Your password is %@",@"ModifiedDate":@"0000-00-00 00:00:00"},@{@"EnumNo":@"7",@"EnumKey":@"emailInvalid",@"Message":@"Email address is invalid.",@"ModifiedDate":@"0000-00-00 00:00:00"},@{@"EnumNo":@"8",@"EnumKey":@"emailExisted",@"Message":@"This email address has already existed.",@"ModifiedDate":@"2015-08-11 11:22:52"},@{@"EnumNo":@"9",@"EnumKey":@"wrongEmail",@"Message":@"Wrong registered email",@"ModifiedDate":@"0000-00-00 00:00:00"},@{@"EnumNo":@"10",@"EnumKey":@"wrongPassword",@"Message":@"Wrong old password",@"ModifiedDate":@"0000-00-00 00:00:00"},@{@"EnumNo":@"11",@"EnumKey":@"newPasswordNotMatch",@"Message":@"New passwords do not match.",@"ModifiedDate":@"0000-00-00 00:00:00"},@{@"EnumNo":@"12",@"EnumKey":@"changePasswordSuccess",@"Message":@"Your password has been changed successfully.",@"ModifiedDate":@"0000-00-00 00:00:00"},@{@"EnumNo":@"13",@"EnumKey":@"emailSubjectChangePassword",@"Message":@"Minimalist - Your password has been changed successfully.",@"ModifiedDate":@"0000-00-00 00:00:00"},@{@"EnumNo":@"14",@"EnumKey":@"emailBodyChangePassword",@"Message":@"Your username is %@<br>Your password is %@",@"ModifiedDate":@"0000-00-00 00:00:00"},@{@"EnumNo":@"15",@"EnumKey":@"newPasswordEmpty",@"Message":@"New password cannot be empty.",@"ModifiedDate":@"0000-00-00 00:00:00"},@{@"EnumNo":@"16",@"EnumKey":@"passwordEmpty",@"Message":@"Password cannot be empty.",@"ModifiedDate":@"0000-00-00 00:00:00"},@{@"EnumNo":@"17",@"EnumKey":@"passwordChanged",@"Message":@"Password has changed.",@"ModifiedDate":@"2015-08-11 11:23:49"},@{@"EnumNo":@"18",@"EnumKey":@"emailSubjectForgotPassword",@"Message":@"Minimalist - Your password is reset.",@"ModifiedDate":@"0000-00-00 00:00:00"},@{@"EnumNo":@"19",@"EnumKey":@"emailBodyForgotPassword",@"Message":@"Your username is %@<br>Your password is %@",@"ModifiedDate":@"0000-00-00 00:00:00"},@{@"EnumNo":@"20",@"EnumKey":@"forgotPasswordReset",@"Message":@"Mail sent",@"ModifiedDate":@"0000-00-00 00:00:00"},@{@"EnumNo":@"21",@"EnumKey":@"forgotPasswordMailSent",@"Message":@"Mail sent successfully",@"ModifiedDate":@"0000-00-00 00:00:00"},@{@"EnumNo":@"22",@"EnumKey":@"locationEmpty",@"Message":@"Location cannot be empty.",@"ModifiedDate":@"0000-00-00 00:00:00"},@{@"EnumNo":@"23",@"EnumKey":@"periodFromEmpty",@"Message":@"Period From cannot be empty.",@"ModifiedDate":@"0000-00-00 00:00:00"},@{@"EnumNo":@"24",@"EnumKey":@"periodToEmpty",@"Message":@"Period To cannot be empty.",@"ModifiedDate":@"0000-00-00 00:00:00"},@{@"EnumNo":@"25",@"EnumKey":@"deleteSubject",@"Message":@"Confirm delete",@"ModifiedDate":@"0000-00-00 00:00:00"},@{@"EnumNo":@"26",@"EnumKey":@"confirmDeleteUserAccount",@"Message":@"Delete user account",@"ModifiedDate":@"0000-00-00 00:00:00"},@{@"EnumNo":@"27",@"EnumKey":@"confirmDeleteEvent",@"Message":@"Delete event",@"ModifiedDate":@"0000-00-00 00:00:00"},@{@"EnumNo":@"28",@"EnumKey":@"periodToLessThanPeriodFrom",@"Message":@"Period to is less than Period from.",@"ModifiedDate":@"2015-07-27 01:01:50"},@{@"EnumNo":@"29",@"EnumKey":@"noEventChosenSubject",@"Message":@"No event chosen",@"ModifiedDate":@"2015-08-09 17:31:47"},@{@"EnumNo":@"30",@"EnumKey":@"noEventChosenDetail",@"Message":@"No event chosen, create event in Event menu",@"ModifiedDate":@"2015-08-09 17:31:47"},@{@"EnumNo":@"31",@"EnumKey":@"codeMismatch",@"Message":@"Code mismatch",@"ModifiedDate":@"2015-08-10 18:36:13"},@{@"EnumNo":@"32",@"EnumKey":@"passwordIncorrect",@"Message":@"Incorrect password",@"ModifiedDate":@"2015-08-10 20:46:06"},@{@"EnumNo":@"33",@"EnumKey":@"EmailIncorrect",@"Message":@"Incorrect email",@"ModifiedDate":@"2015-08-11 11:05:00"}];
    
    for (int i = 0; i < jsonArrayMessage.count; i++)
    {
        NSDictionary *jsonElement = jsonArrayMessage[i];
        
        InAppMessage *message = [[InAppMessage alloc] init];
        message.enumNo = jsonElement[@"EnumNo"];
        message.enumKey = jsonElement[@"EnumKey"];
        message.message = jsonElement[@"Message"];
        message.modifiedDate = jsonElement[@"ModifiedDate"];
        
        [arrItemMessage addObject:message];
    }
    globalMessage = arrItemMessage;
    
    
    [self.homeModel downloadItems:dbMasterWithProgressBar];
}

- (void)applicationExpired
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Warning"
                                                                   message:@"Application is expired"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        
                                    }];
    
    [alert addAction:defaultAction];
    dispatch_async(dispatch_get_main_queue(),^ {
        [self presentViewController:alert animated:YES completion:nil];
    } );
    return;
}
- (void)downloadProgress:(float)percent
{
    progressBar.progress = percent;
    //    NSLog([NSString stringWithFormat:@"%f",percent]);
}
-(void)itemsDownloaded:(NSArray *)items
{
    if([items count] == 0)
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Warning"
                                                                       message:@"Memory fail"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action)
                                        {
                                            
                                        }];
        
        [alert addAction:defaultAction];
        dispatch_async(dispatch_get_main_queue(),^ {
            [self presentViewController:alert animated:YES completion:nil];
        } );
        return;
    }

    {
        PushSync *pushSync = [[PushSync alloc]init];
        pushSync.deviceToken = [Utility deviceToken];
        [self.homeModel updateItems:dbPushSyncUpdateByDeviceToken withData:pushSync actionScreen:@"update synced time by device token"];
    }
    
    
    [Utility itemsDownloaded:items];
    
    [Utility setFinishLoadSharedData:YES];
    dispatch_async(dispatch_get_main_queue(),^ {
        [self performSegueWithIdentifier:@"segSignIn" sender:self];
    } );
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    progressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    
    {
        CGRect frame = progressBar.frame;
        frame.size.width = self.view.frame.size.width-200;
        progressBar.frame = frame;
    }
    progressBar.center = self.view.center;
    
    {
        CGRect frame = progressBar.frame;
        frame.origin.y = self.view.frame.size.height-20;
        progressBar.frame = frame;
    }
    
    [self.view addSubview:progressBar];
}


@end
