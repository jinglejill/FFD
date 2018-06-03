//
//  SharedMenuTypeNote.h
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/12/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedMenuTypeNote : NSObject
@property (retain, nonatomic) NSMutableArray *menuTypeNoteList;

+ (SharedMenuTypeNote *)sharedMenuTypeNote;
@end
