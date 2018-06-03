//
//  LogInViewController.h
//  Eventoree
//
//  Created by Thidaporn Kijkamjai on 8/31/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomViewController.h"

@interface LogInViewController : CustomViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *txtUsername;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UIButton *btnLogIn;
- (IBAction)logIn:(id)sender;
- (IBAction)unwindToLogIn:(UIStoryboardSegue *)segue;
@end
