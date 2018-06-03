//
//  SharedMenuType.h
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/9/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedMenuType : NSObject
@property (retain, nonatomic) NSMutableArray *menuTypeList;

+ (SharedMenuType *)sharedMenuType;

@end
