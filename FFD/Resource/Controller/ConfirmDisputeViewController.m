//
//  ConfirmDisputeViewController.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 10/5/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "ConfirmDisputeViewController.h"
#import "DisputeFormViewController.h"
#import "Setting.h"


@interface ConfirmDisputeViewController ()

@end

@implementation ConfirmDisputeViewController
@synthesize lblDisputeMessage;
@synthesize vwAlertHeight;
@synthesize lblDisputeMessageHeight;
@synthesize vwAlert;
@synthesize fromType;
@synthesize receipt;


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    lblDisputeMessageHeight.constant = lblDisputeMessage.frame.size.height;
    vwAlertHeight.constant = 80+38+38+44+lblDisputeMessage.frame.size.height;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    NSString *strMessageHeader;
    NSString *strMessageSubTitle;
    if(fromType == 1)
    {
        strMessageHeader = [Setting getSettingValueWithKeyName:@"MessageHeaderCancel"];
        strMessageSubTitle = [Setting getSettingValueWithKeyName:@"MessageSubTitleCancel"];
    }
    else if(fromType == 2)
    {
        strMessageHeader = [Setting getSettingValueWithKeyName:@"MessageHeaderDispute"];
        strMessageSubTitle = [Setting getSettingValueWithKeyName:@"MessageSubTitleDispute"];
    }
    else if(fromType == 3)
    {
        strMessageHeader = [Setting getSettingValueWithKeyName:@"MessageHeaderCancelShop"];
        strMessageSubTitle = [Setting getSettingValueWithKeyName:@"MessageSubTitleCancelShop"];
//        strMessageHeader = @"Oop!";
//        strMessageSubTitle = @"คุณต้องการที่จะ cancel order ใช่หรือไม่";
    }
    else if(fromType == 4)
    {
        strMessageHeader = [Setting getSettingValueWithKeyName:@"MessageHeaderRefundShop"];
        strMessageSubTitle = [Setting getSettingValueWithKeyName:@"MessageSubTitleRefundShop"];
//        strMessageHeader = @"Oop!";
//        strMessageSubTitle = @"คุณต้องการที่จะ refund เงินคืนลูกค้า ใช่หรือไม่";
    }
    UIFont *font = [UIFont boldSystemFontOfSize:22];
    UIColor *color = [UIColor darkGrayColor];
    NSDictionary *attribute = @{NSForegroundColorAttributeName:color ,NSFontAttributeName: font};
    NSMutableAttributedString *attrStringHeader = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n\n",strMessageHeader] attributes:attribute];
    
    
    UIFont *font2 = [UIFont systemFontOfSize:15];
    UIColor *color2 = [UIColor darkGrayColor];
    NSDictionary *attribute2 = @{NSForegroundColorAttributeName:color2 ,NSFontAttributeName: font2};
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:strMessageSubTitle attributes:attribute2];
    
    
    [attrStringHeader appendAttributedString:attrString];
    
    
    
    lblDisputeMessage.attributedText = attrStringHeader;
    [lblDisputeMessage sizeToFit];
    
    
    vwAlert.layer.cornerRadius = 10;
    vwAlert.layer.masksToBounds = YES;
}

- (IBAction)yesDispute:(id)sender
{
    [self performSegueWithIdentifier:@"segDisputeForm" sender:self];
}

- (IBAction)noDispute:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToOrderDetail" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segDisputeForm"])
    {
        DisputeFormViewController *vc = segue.destinationViewController;
        vc.fromType = fromType;
        vc.receipt = receipt;
    }
}
@end
