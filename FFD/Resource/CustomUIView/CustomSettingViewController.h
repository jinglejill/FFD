//
//  CustomSettingViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 11/10/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "CustomViewController.h"

@interface CustomSettingViewController : CustomViewController
@property (nonatomic) enum settingGroup settingGroup;

- (void)unwindToSettingDetail;
@end
