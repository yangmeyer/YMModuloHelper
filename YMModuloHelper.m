
//  Created by Yang Meyer on 11.01.13.
//  Copyright 2013 Yang Meyer. All rights reserved.

#import "YMModuloHelper.h"

@interface YMModuloHelper ()
@property (nonatomic, readwrite) NSUInteger count;
@end


@implementation YMModuloHelper

- (instancetype)initWithCount:(NSUInteger)count {
	NSParameterAssert(count >= 2);
	self = [super init];
	if (self) {
		self.count = count;
	}
	return self;
}

- (id)init {
	return [self initWithCount:0];
}

+ (instancetype)moduloHelperWithCount:(NSUInteger)count {
	return [[self alloc] initWithCount:count];
}

#pragma mark - Normalization

- (NSUInteger)normalizedIndex:(NSInteger)index {
    NSInteger result = index % (NSInteger)self.count;
    if (result < 0) result += (NSInteger)self.count;
	NSAssert(0 <= result && result < (NSInteger)self.count, @"Normalizing perspective failed");
    return (NSUInteger)result;
}

#pragma mark - Distance

- (NSUInteger)clockwiseDistanceFrom:(NSUInteger)from to:(NSUInteger)to {
	NSInteger naive = (NSInteger)to - (NSInteger)from;
	return (naive < 0
			? self.count + (NSUInteger)naive
			: (NSUInteger)naive);
}

- (NSUInteger)counterClockwiseDistanceFrom:(NSUInteger)from to:(NSUInteger)to {
	return [self clockwiseDistanceFrom:to to:from];
}

- (NSUInteger)shortestDistanceBetween:(NSUInteger)from and:(NSUInteger)to {
	return (NSUInteger) MIN([self clockwiseDistanceFrom:from to:to], [self counterClockwiseDistanceFrom:from to:to]);
}

#pragma mark - Nearest

- (NSUInteger)nearestIndexOfCandidates:(NSIndexSet *)candidateSet clockwiseFrom:(NSUInteger)from  {
	NSParameterAssert([candidateSet count] > 0);
	
	// pathological shortcut
	if ([candidateSet containsIndex:from])
		return from;
	
	// iterate clockwise, check inclusion in candidateSet
	__block NSUInteger result = NSNotFound;
	// implementation note: because we can't stop enumerating once we've found a candidate index, we actually iterate counter-clockwise so that the LAST candidate index to match counter-clockwise is the clockwise-nearest.
	NSUInteger end = [self normalizedIndex:(NSInteger)from + 1];
	[self enumerateIndexesOnCounterClockwisePathFrom:from through:end withBlock:^(NSUInteger idx) {
		if ([candidateSet containsIndex:idx]) {
			result = idx;
		}
	}];
	return result;
}


- (NSUInteger)nearestIndexOfCandidates:(NSIndexSet *)candidateSet counterClockwiseFrom:(NSUInteger)from {
	NSParameterAssert([candidateSet count] > 0);
	
	// pathological shortcut
	if ([candidateSet containsIndex:from])
		return from;
	
	// iterate clockwise, check inclusion in candidateSet
	__block NSUInteger result = NSNotFound;
	// implementation note: see above - vice versa!
	NSUInteger end = [self normalizedIndex:(NSInteger)from - 1];
	[self enumerateIndexesOnClockwisePathFrom:from through:end withBlock:^(NSUInteger idx) {
		if ([candidateSet containsIndex:idx]) {
			result = idx;
		}
	}];
	return result;
}

- (NSUInteger)nearestIndexOfCandidates:(NSIndexSet *)candidateSet from:(NSUInteger)from {
	NSParameterAssert([candidateSet count] > 0);
	
	// pathological shortcut
	if ([candidateSet containsIndex:from])
		return from;
	
	// iterate over all candidates
	__block NSUInteger nearestIndex = NSNotFound;
	__block NSUInteger shortestDistance = self.count / 2;
	[candidateSet enumerateIndexesUsingBlock:^(NSUInteger toIndex, BOOL *stop) {
		NSUInteger distance = [self shortestDistanceBetween:from and:toIndex];
		if (distance <= shortestDistance) {
			shortestDistance = distance;
			nearestIndex = toIndex;
		}
	}];
	return nearestIndex;
}

#pragma mark - Iteration

- (void)enumerateIndexesOnClockwisePathFrom:(NSUInteger)from through:(NSUInteger)to withBlock:(YMIndexEnumerationBlock)block {
	// pathological shortcut
	if (from == to) {
		block(from);
		return;
	}
	
	for (NSInteger i = from; [self clockwiseDistanceFrom:i to:to] != (NSUInteger) 0; i++) {
		block([self normalizedIndex:i]);
	}
	block(to);
}

- (void)enumerateIndexesOnCounterClockwisePathFrom:(NSUInteger)from through:(NSUInteger)to withBlock:(YMIndexEnumerationBlock)block {
	// pathological shortcut
	if (from == to) {
		block(from);
		return;
	}
	
	for (NSInteger i = from; [self counterClockwiseDistanceFrom:i to:to] != (NSUInteger) 0; i--) {
		block([self normalizedIndex:i]);
	}
	block(to);
}

- (void)enumerateIndexesOnShortestPathFrom:(NSUInteger)from through:(NSUInteger)to withBlock:(YMIndexEnumerationBlock)block {
	if ([self clockwiseDistanceFrom:from to:to] < [self counterClockwiseDistanceFrom:from to:to]) {
		[self enumerateIndexesOnClockwisePathFrom:from through:to withBlock:block];
	} else {
		[self enumerateIndexesOnCounterClockwisePathFrom:from through:to withBlock:block];
	}
}

@end
