//
//  LaunchWithLogoViewController.h
//  Eventoree
//
//  Created by Thidaporn Kijkamjai on 8/30/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "HomeModel.h"


@interface LaunchWithLogoViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate,HomeModelProtocol>
@property (strong, nonatomic) IBOutlet UIProgressView *progressBar;
@property (strong, nonatomic) IBOutlet UIImageView *imgLogo;

@end
