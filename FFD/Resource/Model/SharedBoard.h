//
//  SharedBoard.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 12/7/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedBoard : NSObject
@property (retain, nonatomic) NSMutableArray *boardList;

+ (SharedBoard *)sharedBoard;
@end
