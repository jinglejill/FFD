//
//  SharedIngredientReceive.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/26/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedIngredientReceive : NSObject
@property (retain, nonatomic) NSMutableArray *ingredientReceiveList;

+ (SharedIngredientReceive *)sharedIngredientReceive;

@end
