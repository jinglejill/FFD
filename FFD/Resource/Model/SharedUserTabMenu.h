//
//  SharedUserTabMenu.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 11/19/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedUserTabMenu : NSObject
@property (retain, nonatomic) NSMutableArray *userTabMenuList;

+ (SharedUserTabMenu *)sharedUserTabMenu;
@end
