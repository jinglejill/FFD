//
//  SharedIngredientCheck.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/26/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedIngredientCheck : NSObject
@property (retain, nonatomic) NSMutableArray *ingredientCheckList;

+ (SharedIngredientCheck *)sharedIngredientCheck;
@end
