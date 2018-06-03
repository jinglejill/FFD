//
//  LogInViewController.m
//  Eventoree
//
//  Created by Thidaporn Kijkamjai on 8/31/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "LogInViewController.h"
#import "MainTabBarController.h"
#import "KeychainWrapper.h"
#import "Utility.h"
#import "UserAccount.h"
#import "Login.h"
#import "Setting.h"



@interface LogInViewController ()

@end

@implementation LogInViewController
@synthesize txtUsername;
@synthesize txtPassword;
@synthesize btnLogIn;
@synthesize imgLogo;
@synthesize btnCheckBoxRememberMe;
@synthesize credentialsDb;


- (IBAction)unwindToLogIn:(UIStoryboardSegue *)segue
{
    txtUsername.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"logInUsername"];
    txtPassword.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"logInPassword"];
    btnCheckBoxRememberMe.selected = [[NSUserDefaults standardUserDefaults] boolForKey:@"rememberMe"];
    if(btnCheckBoxRememberMe.selected)
    {
        [btnCheckBoxRememberMe setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateSelected];
    }
    else
    {
        [btnCheckBoxRememberMe setImage:[UIImage imageNamed:@"uncheckbox.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)checkBoxRememberMe:(id)sender
{
    UIButton *button = sender;
    button.selected = !button.selected;
    if(button.selected)
    {
        [button setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateSelected];
    }
    else
    {
        [button setImage:[UIImage imageNamed:@"uncheckbox.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)rememberMe:(id)sender
{
    [self checkBoxRememberMe:btnCheckBoxRememberMe];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [btnLogIn sendActionsForControlEvents: UIControlEventTouchUpInside];
    return NO;
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
    
    
    txtUsername.delegate = self;
    txtPassword.delegate = self;
    
    [self setButtonDesign:btnLogIn];
    
    
    
    //test
#if (TARGET_OS_SIMULATOR)
    {
        Setting *setting = [Setting getSettingWithKeyName:@"printBill"];
        setting.value = 0;
    }
    {
        Setting *setting = [Setting getSettingWithKeyName:@"openCashDrawer"];
        setting.value = 0;
    }
    #endif
    
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
//    NSString *username = @"por";
//    NSString *password = @"por";
//    NSString *fullName = @"por";
//
//
//    UserAccount *userAccount = [[UserAccount alloc]initWithUsername:username password:password deviceToken:[Utility deviceToken] fullName:fullName nickName:@"" email:@"" phoneNo:@"" lineID:@""];
//    [UserAccount addObject:userAccount];
//    [self.homeModel insertItems:dbUserAccount withData:userAccount actionScreen:@"Add user account in Login screen"];




    txtUsername.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"logInUsername"];
    txtPassword.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"logInPassword"];
    btnCheckBoxRememberMe.selected = [[NSUserDefaults standardUserDefaults] boolForKey:@"rememberMe"];
    btnCheckBoxRememberMe.imageView.image = btnCheckBoxRememberMe.selected?[UIImage imageNamed:@"checkbox.png"]:[UIImage imageNamed:@"uncheckbox.png"];
    
    
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
    
    
    if(btnCheckBoxRememberMe.selected)
    {
        [[NSUserDefaults standardUserDefaults] setValue:[Utility trimString:txtUsername.text] forKey:@"logInUsername"];
        [[NSUserDefaults standardUserDefaults] setValue:[Utility trimString:txtPassword.text] forKey:@"logInPassword"];
        [[NSUserDefaults standardUserDefaults] setBool:1 forKey:@"rememberMe"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"logInUsername"];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"logInPassword"];
        [[NSUserDefaults standardUserDefaults] setBool:0 forKey:@"rememberMe"];
    }
    
    

    NSString *modifiedUser = [NSString stringWithFormat:@"%@",txtUsername.text];
    [Utility setModifiedUser:modifiedUser];
    NSLog(@"setModifiedUser: %@",[Utility modifiedUser]);
    

    //check device token ในระบบ ว่าตรงกับตัวเองมั๊ย ถ้าไม่ตรงให้ไป alert ที่อีกเครื่องหนึ่ง
    UserAccount *userAccount = [UserAccount getUserAccountWithUsername:txtUsername.text];
    if(![userAccount.deviceToken isEqualToString:[Utility deviceToken]])
    {
        NSLog(@"useraccount.devicetoken, TOKEN:%@,%@",userAccount.deviceToken,[Utility deviceToken]);
    }
    else
    {
        NSLog(@"equal useraccount.devicetoken, TOKEN:%@,%@",userAccount.deviceToken,[Utility deviceToken]);
    }
    //useraccount table
    userAccount.deviceToken = [Utility deviceToken];
    userAccount.modifiedUser = [Utility modifiedUser];
    userAccount.modifiedDate = [Utility currentDateTime];
    [self.homeModel updateItems:dbUserAccountDeviceToken withData:userAccount actionScreen:@"User account device token"];
    
    
    //login table
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


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"segCustomerTable"])
    {
        MainTabBarController *vc = segue.destinationViewController;
        vc.credentialsDb = credentialsDb;
    }
    
}
@end
