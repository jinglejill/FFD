//
//  SharedMenuIngredient.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/12/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedMenuIngredient : NSObject
@property (retain, nonatomic) NSMutableArray *menuIngredientList;

+ (SharedMenuIngredient *)sharedMenuIngredient;
@end
