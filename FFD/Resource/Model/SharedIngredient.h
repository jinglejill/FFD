//
//  SharedIngredient.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/13/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedIngredient : NSObject
@property (retain, nonatomic) NSMutableArray *ingredientList;

+ (SharedIngredient *)sharedIngredient;
@end
