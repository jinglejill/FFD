//
//  SharedIngredientType.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/13/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedIngredientType : NSObject
@property (retain, nonatomic) NSMutableArray *ingredientTypeList;

+ (SharedIngredientType *)sharedIngredientType;
@end
