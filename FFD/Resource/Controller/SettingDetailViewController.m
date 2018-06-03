//
//  SettingDetailViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 11/10/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SettingDetailViewController.h"

@interface SettingDetailViewController ()

@end

@implementation SettingDetailViewController
@synthesize settingGroup;


- (void)segToVCWithSettingGroup:(enum settingGroup)settingGroup
{
    switch (settingGroup)
    {
        case settingGroupPrinter:
        {
            [self performSegueWithIdentifier:@"segSettingPrinter" sender:self];
            return;
        }
        break;
        case settingGroupPromotion:
        {
            [self performSegueWithIdentifier:@"segSettingPromotion" sender:self];
            return;
        }
            break;
        case settingGroupReward:
        {
            [self performSegueWithIdentifier:@"segSettingReward" sender:self];
            return;
        }
            break;
        case settingGroupDiscount:
        {
            [self performSegueWithIdentifier:@"segSettingDiscount" sender:self];
            return;
        }
            break;
        default:
        break;
    }
    [self performSegueWithIdentifier:@"segSettingBlank" sender:self];
}

- (IBAction)unwindToSettingDetail:(UIStoryboardSegue *)segue
{
    CustomSettingViewController *vc = segue.sourceViewController;
    settingGroup = vc.settingGroup;    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CustomSettingViewController *vc = segue.destinationViewController;
    vc.settingGroup = settingGroup;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self segToVCWithSettingGroup:settingGroup];
}

- (void)loadView
{
    [super loadView];
    
    
    [self loadViewProcess];
    
}

- (void)loadViewProcess
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture setCancelsTouchesInView:NO];
}

@end
