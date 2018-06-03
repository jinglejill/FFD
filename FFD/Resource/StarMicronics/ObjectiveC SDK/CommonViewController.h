//
//  CommonViewController.h
//  ObjectiveC SDK
//
//  Created by Yuji on 2015/**/**.
//  Copyright (c) 2015年 Star Micronics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *blindView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic) BOOL blind;

- (void)appendRefreshButton:(SEL)action;

@end
