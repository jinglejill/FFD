//
//  LaunchWithLogoViewController.m
//  Eventoree
//
//  Created by Thidaporn Kijkamjai on 8/30/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "LaunchWithLogoViewController.h"
#import "BranchSelectViewController.h"
#import "LogInViewController.h"
#import "ChristmasConstants.h"
#import "KeychainWrapper.h"
#import "Utility.h"
#import "PushSync.h"
#import "Credentials.h"
#import "CredentialsDb.h"
#import "Device.h"
#import "Message.h"
#import <sys/utsname.h>
#include "TargetConditionals.h"



//extern NSArray *globalMessage;
@interface LaunchWithLogoViewController ()
{
    UIActivityIndicatorView *indicator;
    UIView *overlayView;
    HomeModel *_homeModel;
    NSMutableArray *_credentialsDbList;
    CredentialsDb *_credentialsDb;
}
@end

@implementation LaunchWithLogoViewController
@synthesize progressBar;
@synthesize imgLogo;


- (void)presentAlertViewForPassword
{
    
    // 1
    BOOL hasPin = [[NSUserDefaults standardUserDefaults] boolForKey:PIN_SAVED];
    
    // 2
    if (hasPin)
    {
        //download branch
        _homeModel = [[HomeModel alloc]init];
        _homeModel.delegate = self;
        [_homeModel downloadItems:dbCredentialsDb withData:[[NSUserDefaults standardUserDefaults] stringForKey:USERNAME]];

        
        //        [self downloadData];
    }
    else
    {
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
    _homeModel = [[HomeModel alloc]init];
    _homeModel.delegate = self;
    [_homeModel insertItems:dbCredentials withData:credentials actionScreen:@"Validate credential"];
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

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGRect frame = imgLogo.frame;
    frame.size.width = frame.size.height*imgLogo.image.size.width/imgLogo.image.size.height;
    imgLogo.frame = frame;
}

- (void)loadView
{
    [super loadView];
    NSLog(@"test screen size %f,%f",self.view.frame.size.width,self.view.frame.size.height);
    _homeModel = [[HomeModel alloc]init];
    _homeModel.delegate = self;
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:USERNAME]);//db
    
    {
        overlayView = [[UIView alloc] initWithFrame:self.view.frame];
        overlayView.backgroundColor = [UIColor colorWithRed:256 green:256 blue:256 alpha:0];
        
        
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.frame = CGRectMake(self.view.bounds.size.width/2-indicator.frame.size.width/2,self.view.bounds.size.height/2-indicator.frame.size.height/2,indicator.frame.size.width,indicator.frame.size.height);
    }
    
    [self presentAlertViewForPassword];
}

- (void)loadViewProcess
{
    [self presentAlertViewForPassword];
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
}

-(void)itemsInserted
{
    if(_homeModel.propCurrentDBInsert == dbCredentials)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:PIN_SAVED];
        [self presentAlertViewForPassword];
    }
    else if(_homeModel.propCurrentDBInsert == dbDevice)
    {
        [self downloadData];
    }
}

- (void)downloadData
{
    _homeModel = [[HomeModel alloc]init];
    _homeModel.delegate = self;
    [_homeModel downloadItems:dbMasterWithProgressBar];
}

- (void)itemsDownloaded:(NSArray *)items
{
    if(_homeModel.propCurrentDB == dbCredentialsDb)
    {
        [self removeOverlayViews];
        _credentialsDbList = items[0];
        
        
        if([_credentialsDbList count]==1)
        {
            _credentialsDb = _credentialsDbList[0];
            [Utility setBranchID:_credentialsDb.branchID];
            [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] stringForKey:USERNAME] forKey:BRANCH];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            
            //insert device for pushNotification to update data in the same branch, so delete deviceToken that stay in other db(เพราะได้ switch มาใช้ branch นี้แล้ว)
            Device *device = [[Device alloc]init];
            device.deviceToken = [Utility deviceToken];
            device.remark = [self deviceName];
            _homeModel = [[HomeModel alloc]init];
            _homeModel.delegate = self;
            [_homeModel insertItems:dbDevice withData:device actionScreen:@"Add device in branchSelect screen"];
            
        }
        else
        {
            [self performSegueWithIdentifier:@"segBranchSelect" sender:self];
        }
    }
    else if(_homeModel.propCurrentDB == dbMasterWithProgressBar)
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
            _homeModel = [[HomeModel alloc]init];
            _homeModel.delegate = self;
            [_homeModel updateItems:dbPushSyncUpdateByDeviceToken withData:pushSync actionScreen:@"update synced time by device token"];
        }
        
        
        
        [Utility itemsDownloaded:items];
        [self removeOverlayViews];//อาจ มีการเรียกจากหน้า customViewController
        
        
        
        [Utility setFinishLoadSharedData:YES];
        [self performSegueWithIdentifier:@"segSignIn" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segBranchSelect"])
    {
        BranchSelectViewController *vc = segue.destinationViewController;
        vc.credentialsDbList = _credentialsDbList;
    }
    else if([[segue identifier] isEqualToString:@"segSignIn"])
    {
        LogInViewController *vc = segue.destinationViewController;
        vc.credentialsDb = _credentialsDb;
    }
}

- (void)viewDidLoad
{
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

-(void) loadingOverlayView
{
    [indicator startAnimating];
    indicator.layer.zPosition = 1;
    indicator.alpha = 1;
    
    
    // and just add them to navigationbar view
    [self.view addSubview:overlayView];
    [self.view addSubview:indicator];
}

-(void) removeOverlayViews{
    UIView *view = overlayView;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         view.alpha = 0.0;
                         indicator.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         dispatch_async(dispatch_get_main_queue(),^ {
                             [view removeFromSuperview];
                             [indicator stopAnimating];
                             [indicator removeFromSuperview];
                         } );
                     }
     ];
}

- (void) connectionFail
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:[Utility subjectNoConnection]
                                                                   message:[Utility detailNoConnection]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {                                        
                                        if(![indicator isAnimating])
                                        {
                                            [self loadingOverlayView];
                                        }
                                        _homeModel = [[HomeModel alloc]init];
                                        _homeModel.delegate = self;
                                        [_homeModel downloadItems:dbMaster];
                                    }];
    
    [alert addAction:defaultAction];
    dispatch_async(dispatch_get_main_queue(),^ {
        [self presentViewController:alert animated:YES completion:nil];
    } );
}

- (void)itemsFail
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:[Utility getConnectionLostTitle]
                                                                   message:[Utility getConnectionLostMessage]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              if(![indicator isAnimating])
                                                              {
                                                                  [self loadingOverlayView];
                                                              }
                                                              _homeModel = [[HomeModel alloc]init];
                                                              _homeModel.delegate = self;
                                                              [_homeModel downloadItems:dbMaster];
                                                          }];
    
    [alert addAction:defaultAction];
    dispatch_async(dispatch_get_main_queue(),^ {
        [self presentViewController:alert animated:YES completion:nil];
    } );
}

- (void)alertMsg:(NSString *)msg
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [self presentAlertViewForPassword];
                                    }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)itemsUpdated
{
    
}

-(NSString*) deviceName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    
    NSString *iOSDeviceModelsPath = [[NSBundle mainBundle] pathForResource:@"iOSDeviceModelMapping" ofType:@"plist"];
    NSDictionary *iOSDevices = [NSDictionary dictionaryWithContentsOfFile:iOSDeviceModelsPath];
    
    NSString* deviceModel = [NSString stringWithCString:systemInfo.machine
                                               encoding:NSUTF8StringEncoding];
    
    return [iOSDevices valueForKey:deviceModel];
}

@end
