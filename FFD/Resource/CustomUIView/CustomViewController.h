//
//  CustomViewController.h
//  Eventoree
//
//  Created by Thidaporn Kijkamjai on 8/29/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
#import "Utility.h"


@interface CustomViewController : UIViewController<HomeModelProtocol>
@property (nonatomic,retain) HomeModel *homeModel;
@property (nonatomic,retain) UIActivityIndicatorView *indicator;
@property (nonatomic,retain) UIView *overlayView;


-(void)loadingOverlayView;
-(void)removeOverlayViews;
-(void)connectionFail;
-(void)itemsFail;
-(void)itemsInserted;
-(void)itemsUpdated;
-(void)syncItems;
-(void) showAlert:(NSString *)title message:(NSString *)message;
-(void)showAlertAndCallPushSync:(NSString *)title message:(NSString *)message;
-(void)loadViewProcess;
-(void)setShadow:(UIView *)view;
-(void)setShadow:(UIView *)view radius:(NSInteger)radius;
-(void)setCornerAndShadow:(UIView *)view;
-(void)setCornerAndShadow:(UIView *)view radius:(NSInteger)radius;
@end
