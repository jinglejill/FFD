//
//  SharedMember.h
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/17/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedMember : NSObject
@property (retain, nonatomic) NSMutableArray *memberList;

+ (SharedMember *)sharedMember;
@end
