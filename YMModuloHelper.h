
//  Created by Yang Meyer on 11.01.13.
//  Copyright 2013 Yang Meyer. All rights reserved.

#import <Foundation/Foundation.h>

@interface YMModuloHelper : NSObject

// Designated initializer.
- (instancetype)initWithCount:(NSUInteger)count;
+ (instancetype)moduloHelperWithCount:(NSUInteger)count;

@property (nonatomic, readonly) NSUInteger count;

#pragma mark - Normalization

- (NSUInteger)normalizedIndex:(NSInteger)index;

#pragma mark - Distance

- (NSUInteger)clockwiseDistanceFrom:(NSUInteger)from to:(NSUInteger)to;
- (NSUInteger)counterClockwiseDistanceFrom:(NSUInteger)from to:(NSUInteger)to;
- (NSUInteger)shortestDistanceBetween:(NSUInteger)from and:(NSUInteger)to;

#pragma mark - Iteration

- (void)enumerateIndexesOnShortestPathFrom:(NSUInteger)from through:(NSUInteger)to withBlock:(void (^)(NSUInteger idx))block;

@end
