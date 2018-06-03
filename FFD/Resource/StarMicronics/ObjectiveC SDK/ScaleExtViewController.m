//
//  ScaleExtViewController.m
//  ObjectiveC SDK
//
//  Created by Yuji on 2016/**/**.
//  Copyright © 2016年 Star Micronics. All rights reserved.
//

#import "ScaleExtViewController.h"

#import "AppDelegate.h"

#import "ScaleCommunication.h"

#import "ScaleFunctions.h"

typedef NS_ENUM(NSInteger, ScaleStatus) {
    ScaleStatusInvalid = 0,
    ScaleStatusImpossible,
    ScaleStatusConnect,
    ScaleStatusDisconnect
};

@interface ScaleExtViewController ()

@property (nonatomic) SMPort *port;

@property (nonatomic) ScaleStatus scaleStatus;

@property (nonatomic) NSRecursiveLock *lock;

@property (nonatomic) dispatch_group_t dispatchGroup;

@property (nonatomic) dispatch_semaphore_t terminateTaskSemaphore;

- (void)applicationWillResignActive;
- (void)applicationDidBecomeActive;

- (void)refreshScale;

- (BOOL)connect;

- (BOOL)disconnect;

- (void)watchScaleTask;

- (void)beginAnimationCommantLabel;
- (void)endAnimationCommantLabel;

@end

@implementation ScaleExtViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _commentLabel.text = @"";
    
    _commentLabel.adjustsFontSizeToFitWidth = YES;
    
    _zeroClearButton.enabled           = YES;
//  _zeroClearButton.backgroundColor   = [UIColor cyanColor];
    _zeroClearButton.backgroundColor   = [UIColor colorWithRed:0.8 green:0.8 blue:1.0 alpha:1.0];
    _zeroClearButton.layer.borderColor = [UIColor blueColor].CGColor;
    _zeroClearButton.layer.borderWidth = 1.0;
    
    _unitChangeButton.enabled           = YES;
    _unitChangeButton.backgroundColor   = [UIColor cyanColor];
    _unitChangeButton.layer.borderColor = [UIColor blueColor].CGColor;
    _unitChangeButton.layer.borderWidth = 1.0;
    
    [self appendRefreshButton:@selector(refreshScale)];
    
    _port = nil;
    
    _scaleStatus = ScaleStatusInvalid;
    
    _lock = [NSRecursiveLock new];
    
    _dispatchGroup = dispatch_group_create();
    
    _terminateTaskSemaphore = dispatch_semaphore_create(1);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive)  name:UIApplicationDidBecomeActiveNotification  object:nil];
    
    [self refreshScale];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self disconnect];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification  object:nil];
}

- (void)applicationDidBecomeActive {
    [self beginAnimationCommantLabel];
    
    [self refreshScale];
}

- (void)applicationWillResignActive {
    [self disconnect];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)touchUpInsideZeroClearButton:(id)sender {
    NSData *commands = [ScaleFunctions createZeroClear];
    
    self.blind = YES;
    
    [_lock lock];
    
    if (_scaleStatus == ScaleStatusConnect) {
        [ScaleCommunication passThroughCommands:commands port:_port completionHandler:^(BOOL result, NSString *title, NSString *message) {
            if (result == NO) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alertView show];
            }
        }];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"Scale Disconnect." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
    }
    
    [_lock unlock];
    
    self.blind = NO;
}

- (IBAction)touchUpInsideUnitChangeButton:(id)sender {
    NSData *commands = [ScaleFunctions createUnitChange];
    
    self.blind = YES;
    
    [_lock lock];
    
    if (_scaleStatus == ScaleStatusConnect) {
        [ScaleCommunication passThroughCommands:commands port:_port completionHandler:^(BOOL result, NSString *title, NSString *message) {
            if (result == NO) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alertView show];
            }
        }];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"Scale Disconnect." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
    }
    
    [_lock unlock];
    
    self.blind = NO;
}

- (void)refreshScale {
    self.blind = YES;
    
    [self disconnect];
    
    if ([self connect] == NO) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Fail to Open Port." message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
    }
    
    self.blind = NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    _commentLabel.text = @"Check the device. (Power and Bluetooth pairing)\nThen touch up the Refresh button.";
    
    _commentLabel.textColor = [UIColor redColor];
    
    [self beginAnimationCommantLabel];
}

- (BOOL)connect {
    BOOL result = YES;
    
    if (_port == nil) {
        result = NO;
        
        @try {
            _port = [SMPort getPort:[AppDelegate getPortName] :[AppDelegate getPortSettings] :10000];     // 10000mS!!!
            
            if (_port != nil) {
                StarPrinterStatus_2 status;
                
                [_port getParsedStatus:&status :2];
                
                dispatch_semaphore_wait(_terminateTaskSemaphore, DISPATCH_TIME_FOREVER);
                
                dispatch_group_async(_dispatchGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self watchScaleTask];
                });
                
                result = YES;
            }
        }
        @catch (NSException *exc) {
            [SMPort releasePort:_port];
            
            _port = nil;
        }
    }
    
    return result;
}

- (BOOL)disconnect {
    BOOL result = YES;
    
    if (_port != nil) {
        result = NO;
        
        dispatch_semaphore_signal(_terminateTaskSemaphore);
        
        dispatch_group_wait(_dispatchGroup, DISPATCH_TIME_FOREVER);
        
        [SMPort releasePort:_port];
        
        _port = nil;
        
        _scaleStatus = ScaleStatusInvalid;
        
        result = YES;
    }
    
    return result;
}

- (void)watchScaleTask {
    while (YES) {
        @autoreleasepool {
//          BOOL portValid = NO;
            BOOL portValid = YES;
            
            if ([_lock tryLock]) {
                portValid = NO;
                
                if (_port != nil) {
                    if (_port.connected == YES) {
                        portValid = YES;
                    }
                }
                
                if (portValid == YES) {
                    IStarIoExtDisplayedWeightFunction *displayedWeightFunction = [ScaleFunctions createDisplayedWeightFunction];
                    
                    [ScaleCommunication passThroughFunction:displayedWeightFunction port:_port completionHandler:^(BOOL result, NSString *title, NSString *message) {
                        if (result == YES) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                _scaleStatus = ScaleStatusConnect;
                                
                                switch (displayedWeightFunction.status) {
                                    default                                 :
//                                  case StarIoExtDisplayedWeightStatusZero :
                                        _commentLabel.text = displayedWeightFunction.weight;
                                        
//                                      _commentLabel.textColor = [UIColor greenColor];
                                        _commentLabel.textColor = [UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:1.0];
                                        
                                        [self endAnimationCommantLabel];
                                        break;
                                    case StarIoExtDisplayedWeightStatusNotInMotion :
                                        _commentLabel.text = displayedWeightFunction.weight;
                                        
                                        _commentLabel.textColor = [UIColor blueColor];
                                        
                                        [self endAnimationCommantLabel];
                                        break;
                                    case StarIoExtDisplayedWeightStatusMotion :
                                        _commentLabel.text = displayedWeightFunction.weight;
                                        
                                        _commentLabel.textColor = [UIColor redColor];
                                        
                                        [self endAnimationCommantLabel];
                                        break;
                                }
                            });
                        }
                        else {
                            [ScaleCommunication requestStatus:_port completionHandler:^(BOOL result, NSString *title, NSString *message, BOOL connect) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    if (result == YES) {
                                        if (connect == YES) {     // Because the scale doesn't sometimes react.
                                        }
                                        else {
                                            if (_scaleStatus != ScaleStatusDisconnect) {
                                                _scaleStatus = ScaleStatusDisconnect;
                                                
                                                _commentLabel.text = @"Scale Disconnect.";
                                                
                                                _commentLabel.textColor = [UIColor redColor];
                                                
                                                [self beginAnimationCommantLabel];
                                            }
                                        }
                                    }
                                    else {
                                        if (_scaleStatus != ScaleStatusImpossible) {
                                            _scaleStatus = ScaleStatusImpossible;
                                            
//                                          _commentLabel.text = @"Scale Impossible.";
                                            _commentLabel.text = @"Printer Impossible.";
                                            
                                            _commentLabel.textColor = [UIColor redColor];
                                            
                                            [self beginAnimationCommantLabel];
                                        }
                                    }
                                });
                            }];
                        }
                    }];
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (_scaleStatus != ScaleStatusImpossible) {
                            _scaleStatus = ScaleStatusImpossible;
                            
//                          _commentLabel.text = @"Scale Impossible.";
                            _commentLabel.text = @"Printer Impossible.";
                            
                            _commentLabel.textColor = [UIColor redColor];
                            
                            [self beginAnimationCommantLabel];
                        }
                    });
                }
                
                [_lock unlock];
            }
            
            dispatch_time_t timeout;
            
            if (portValid == YES) {
                timeout = dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC);     // 200mS!!!
            }
            else {
                timeout = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);     // 1000mS!!!
            }
            
            if (dispatch_semaphore_wait(_terminateTaskSemaphore, timeout) == 0) {
                dispatch_semaphore_signal(_terminateTaskSemaphore);
                break;
            }
        }
    }
}

- (void)beginAnimationCommantLabel {
    [UIView beginAnimations:nil context:nil];
    
    _commentLabel.alpha = 0.0;
    
    [UIView setAnimationDelay             :0.0];                            // 0mS!!!
    [UIView setAnimationDuration          :0.6];                            // 600mS!!!
    [UIView setAnimationRepeatCount       :UINT32_MAX];
    [UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationCurve             :UIViewAnimationCurveEaseIn];
    
    _commentLabel.alpha = 1.0;
    
    [UIView commitAnimations];
}

- (void)endAnimationCommantLabel {
    [_commentLabel.layer removeAllAnimations];
}

@end
