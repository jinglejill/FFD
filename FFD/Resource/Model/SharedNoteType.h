//
//  SharedNoteType.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 11/15/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedNoteType : NSObject
@property (retain, nonatomic) NSMutableArray *noteTypeList;
+ (SharedNoteType *)sharedNoteType;
@end
