//
//  PrinterExtViewController.h
//  ObjectiveC SDK
//
//  Created by Yuji on 2015/**/**.
//  Copyright (c) 2015年 Star Micronics. All rights reserved.
//

#import "CommonViewController.h"

#import <StarIO_Extension/StarIoExtManager.h>

@interface PrinterExtViewController : CommonViewController <StarIoExtManagerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@property (weak, nonatomic) IBOutlet UIButton *printButton;

- (IBAction)touchUpInsidePrintButton:(id)sender;

@end
