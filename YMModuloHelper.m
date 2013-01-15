
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

- (NSUInteger)nearestIndexFrom:(NSUInteger)from candidates:(NSIndexSet *)candidateSet {
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

- (void)enumerateIndexesOnShortestPathFrom:(NSUInteger)from through:(NSUInteger)to withBlock:(void (^)(NSUInteger idx))block {
	NSUInteger distanceCW = [self clockwiseDistanceFrom:from to:to];
	NSUInteger distanceCCW = [self counterClockwiseDistanceFrom:from to:to];
	
	if (from == to) {
		block(from);
		return;
	}
	
	NSInteger i = from;
	do {
		block([self normalizedIndex:i]);
		if (distanceCW < distanceCCW) {
			i++;
		} else {
			i--;
		}
	} while ([self shortestDistanceBetween:i and:to] != (NSUInteger) 0);
	
	block(to);
}

@end
