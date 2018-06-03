//
//  ScaleExtViewController.h
//  ObjectiveC SDK
//
//  Created by Yuji on 2016/**/**.
//  Copyright © 2016年 Star Micronics. All rights reserved.
//

#import "CommonViewController.h"

@interface ScaleExtViewController : CommonViewController <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@property (weak, nonatomic) IBOutlet UIButton *zeroClearButton;
@property (weak, nonatomic) IBOutlet UIButton *unitChangeButton;

- (IBAction)touchUpInsideZeroClearButton :(id)sender;
- (IBAction)touchUpInsideUnitChangeButton:(id)sender;

@end
