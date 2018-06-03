//
//  SharedNote.h
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/12/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedNote : NSObject
@property (retain, nonatomic) NSMutableArray *noteList;

+ (SharedNote *)sharedNote;

@end
