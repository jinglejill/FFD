//
//  CommonViewController.m
//  ObjectiveC SDK
//
//  Created by Yuji on 2015/**/**.
//  Copyright (c) 2015年 Star Micronics. All rights reserved.
//

#import "CommonViewController.h"

@interface CommonViewController ()

@end

@implementation CommonViewController

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

- (BOOL)getBlind {
    return self.navigationItem.hidesBackButton;
}

- (void)setBlind:(BOOL)blind {
    if (blind == YES) {
        self.navigationItem.hidesBackButton = YES;
        
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
        _blindView            .hidden = NO;
        _activityIndicatorView.hidden = NO;
        
        [_activityIndicatorView startAnimating];
        
        [NSRunLoop.currentRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];     // Update View
    }
    else {
        [_activityIndicatorView stopAnimating];
        
        _blindView            .hidden = YES;
        _activityIndicatorView.hidden = YES;
        
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
        self.navigationItem.hidesBackButton = NO;
        
//      [NSRunLoop.currentRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];     // Update View(No need)
    }
}

- (void)appendRefreshButton:(SEL)action {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                          target:self
                                                                          action:action];
    
    self.navigationItem.rightBarButtonItem = item;
}

@end
