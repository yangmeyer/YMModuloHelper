
//  Created by Yang Meyer on 11.01.13.
//  Copyright 2013 Yang Meyer. All rights reserved.

#import <Foundation/Foundation.h>


enum YMModuloDirection {
	YMModuloDirectionShortest,
	YMModuloDirectionClockwise,
	YMModuloDirectionCounterClockwise,
} typedef YMModuloDirection;


typedef void (^YMIndexEnumerationBlock) (NSUInteger idx);


@interface YMModuloHelper : NSObject

// Designated initializer.
- (instancetype)initWithCount:(NSUInteger)count;
+ (instancetype)moduloHelperWithCount:(NSUInteger)count;

@property (nonatomic, readonly) NSUInteger count;

#pragma mark - Normalization

- (NSUInteger)normalizedIndex:(NSInteger)index;

#pragma mark - Distance
- (NSUInteger)distanceFrom:(NSUInteger)from to:(NSUInteger)to direction:(YMModuloDirection)direction;

- (NSUInteger)clockwiseDistanceFrom:(NSUInteger)from to:(NSUInteger)to __deprecated;
- (NSUInteger)counterClockwiseDistanceFrom:(NSUInteger)from to:(NSUInteger)to __deprecated;
- (NSUInteger)shortestDistanceBetween:(NSUInteger)from and:(NSUInteger)to __deprecated;

#pragma mark - Nearest

// returns one of the indexes in the candidate set with the shortest distance to the `from` index.
- (NSUInteger)nearestIndexOfCandidates:(NSIndexSet *)candidateSet from:(NSUInteger)from;

// returns the (well-defined) index in the candidateSet with the shortest clockwise distance to the `from` index.
- (NSUInteger)nearestIndexOfCandidates:(NSIndexSet *)candidateSet clockwiseFrom:(NSUInteger)from;
- (NSUInteger)nearestIndexOfCandidates:(NSIndexSet *)candidateSet counterClockwiseFrom:(NSUInteger)from;

#pragma mark - Iteration
- (void)enumerateIndexesFrom:(NSUInteger)from through:(NSUInteger)to withBlock:(YMIndexEnumerationBlock)block direction:(YMModuloDirection)direction;

- (void)enumerateIndexesOnClockwisePathFrom:(NSUInteger)from through:(NSUInteger)to withBlock:(YMIndexEnumerationBlock)block __deprecated;
- (void)enumerateIndexesOnCounterClockwisePathFrom:(NSUInteger)from through:(NSUInteger)to withBlock:(YMIndexEnumerationBlock)block __deprecated;
- (void)enumerateIndexesOnShortestPathFrom:(NSUInteger)from through:(NSUInteger)to withBlock:(YMIndexEnumerationBlock)block __deprecated;

@end
