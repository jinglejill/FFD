//
//  DiscountViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/27/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "DiscountViewController.h"
#import "CustomTableViewCellDiscount.h"
#import "CustomTableViewCellMemberRegisterSegment.h"
#import "Discount.h"


@interface DiscountViewController ()
{
    UITextField *_txtDiscountAmount;
    UITextField *_txtReason;
}

@end

@implementation DiscountViewController
static NSString * const reuseIdentifierDiscount = @"CustomTableViewCellDiscount";
static NSString * const reuseIdentifierMemberRegisterSegment = @"CustomTableViewCellMemberRegisterSegment";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

@end
