//
//  LogInViewController.m
//  Eventoree
//
//  Created by Thidaporn Kijkamjai on 8/31/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "LogInViewController.h"
#import "KeychainWrapper.h"
#import "Utility.h"
#import "UserAccount.h"
#import "Login.h"


@interface LogInViewController ()

@end

@implementation LogInViewController
@synthesize txtUsername;
@synthesize txtPassword;
@synthesize btnLogIn;

- (IBAction)unwindToLogIn:(UIStoryboardSegue *)segue
{

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [btnLogIn sendActionsForControlEvents: UIControlEventTouchUpInside];
    return NO;
}

- (void)loadView
{
    [super loadView];
    
    
    txtUsername.delegate = self;
    txtPassword.delegate = self;
    
    [self setCornerAndShadow:btnLogIn];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    txtUsername.textAlignment=NSTextAlignmentCenter;
    txtPassword.textAlignment=NSTextAlignmentCenter;
    txtUsername.font = [UIFont systemFontOfSize:14.0f];
    txtPassword.font = [UIFont systemFontOfSize:14.0f];
    
    
    
//    //test for insert username and password
//    NSString *username = @"jill";
//    NSString *password = @"jill";
//    NSString *fullName = @"นที เรืองจิระชูพร";
//    
//    
//    UserAccount *userAccount = [[UserAccount alloc]initWithUsername:username password:password deviceToken:[Utility deviceToken] fullName:fullName nickName:@"" email:@"" phoneNo:@"" lineID:@""];
//    [UserAccount addObject:userAccount];
//    [self.homeModel insertItems:dbUserAccount withData:userAccount actionScreen:@"Add user account in Login screen"];

    //test
    txtUsername.text = @"jill";
    txtPassword.text = @"jill";
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];    
}

- (IBAction)logIn:(id)sender
{
    [self doLogInProcess];
}

- (void)doLogInProcess
{
    if(![self validateData])
    {
        return;
    }
    
    
    [Utility setModifiedUser:txtUsername.text];
    
    
    //check device token ในระบบ ว่าตรงกับตัวเองมั๊ย ถ้าไม่ตรงให้ไป alert ที่อีกเครื่องหนึ่ง
    UserAccount *userAccount = [UserAccount getUserAccountWithUsername:[Utility modifiedUser]];
    if(![userAccount.deviceToken isEqualToString:[Utility deviceToken]])
    {
        userAccount.deviceToken = [Utility deviceToken];
        userAccount.modifiedUser = [Utility modifiedUser];
        userAccount.modifiedDate = [Utility currentDateTime];
        [self.homeModel updateItems:dbUserAccountDeviceToken withData:userAccount actionScreen:@"User account device token"];
    }
    
    LogIn *logIn = [[LogIn alloc]initWithUsername:[Utility modifiedUser] status:1 deviceToken:[Utility deviceToken]];
    [LogIn addObject:logIn];
    [self.homeModel insertItems:dbLogIn withData:logIn actionScreen:@"Log in"];
    
    
    [UserAccount setCurrentUserAccount:userAccount];
    [self performSegueWithIdentifier:@"segCustomerTable" sender:self];
}

- (BOOL)validateData
{
    txtUsername.text = [Utility trimString:txtUsername.text];
    txtPassword.text = [Utility trimString:txtPassword.text];
    
    if(![UserAccount usernameExist:txtUsername.text])
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:@"ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        return NO;
    }
    if(![UserAccount isPasswordValidWithUsername:txtUsername.text password:txtPassword.text])
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:@"ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        return NO;
    }
    
    return YES;
}

@end
