//
//  SharedAddress.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/21/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedAddress : NSObject
@property (retain, nonatomic) NSMutableArray *addressList;

+ (SharedAddress *)sharedAddress;
@end
