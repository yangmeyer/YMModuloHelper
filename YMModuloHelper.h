
//  Created by Yang Meyer on 11.01.13.
//  Copyright 2013 Yang Meyer. All rights reserved.

#import <Foundation/Foundation.h>


typedef void (^YMIndexEnumerationBlock) (NSUInteger idx);


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

#pragma mark - Nearest

// returns one of the indexes in the candidate set with the shortest distance to the `from` index.
- (NSUInteger)nearestIndexOfCandidates:(NSIndexSet *)candidateSet from:(NSUInteger)from;

// returns the (well-defined) index in the candidateSet with the shortest clockwise distance to the `from` index.
- (NSUInteger)nearestIndexOfCandidates:(NSIndexSet *)candidateSet clockwiseFrom:(NSUInteger)from;
- (NSUInteger)nearestIndexOfCandidates:(NSIndexSet *)candidateSet counterClockwiseFrom:(NSUInteger)from;

#pragma mark - Iteration

- (void)enumerateIndexesOnClockwisePathFrom:(NSUInteger)from through:(NSUInteger)to withBlock:(YMIndexEnumerationBlock)block;
- (void)enumerateIndexesOnCounterClockwisePathFrom:(NSUInteger)from through:(NSUInteger)to withBlock:(YMIndexEnumerationBlock)block;
- (void)enumerateIndexesOnShortestPathFrom:(NSUInteger)from through:(NSUInteger)to withBlock:(YMIndexEnumerationBlock)block;

@end
