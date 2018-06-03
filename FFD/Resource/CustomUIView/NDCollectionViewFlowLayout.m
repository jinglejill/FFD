//
//  NDCollectionViewFlowLayout.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/17/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "NDCollectionViewFlowLayout.h"

@implementation NDCollectionViewFlowLayout
//- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
//    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
//    NSMutableArray *newAttributes = [NSMutableArray arrayWithCapacity:attributes.count];
//    for (UICollectionViewLayoutAttributes *attribute in attributes) {
//        if ((attribute.frame.origin.x + attribute.frame.size.width <= self.collectionViewContentSize.width) &&
//            (attribute.frame.origin.y + attribute.frame.size.height <= self.collectionViewContentSize.height)) {
//            [newAttributes addObject:attribute];
//        }
//    }
//    for (UICollectionViewLayoutAttributes *attrs in attributes) {
//        NSLog(@"old: %f %f", attrs.frame.origin.x, attrs.frame.origin.y);
//    }
//    for (UICollectionViewLayoutAttributes *attrs in newAttributes) {
//        NSLog(@"new:%f %f", attrs.frame.origin.x, attrs.frame.origin.y);
//    }
//    return newAttributes;
//}
//-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
//    return YES;
//}
//- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
//    CGSize size = [self collectionViewContentSize];
//    rect.size.height = size.height*2;
//    NSArray *atrributes_Super = [super layoutAttributesForElementsInRect:rect];
//    return atrributes_Super;
//}
@end
