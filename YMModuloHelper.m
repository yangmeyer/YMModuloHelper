
//  Created by Yang Meyer on 11.01.13.
//  Copyright 2013 Yang Meyer. All rights reserved.

#import "YMModuloHelper.h"

@interface YMModuloHelper ()
@property (nonatomic, readwrite) NSUInteger count;
@end


@implementation YMModuloHelper

- (instancetype)initWithCount:(NSUInteger)count {
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

#pragma mark - Distance

- (NSUInteger)clockwiseDistanceFrom:(NSUInteger)from to:(NSUInteger)to {
	NSInteger naive = (NSInteger)to - (NSInteger)from;
	return (naive < 0
			? self.count + naive
			: naive);
}

- (NSUInteger)counterClockwiseDistanceFrom:(NSUInteger)from to:(NSUInteger)to {
	return [self clockwiseDistanceFrom:to to:from];
}

- (NSUInteger)shortestDistanceBetween:(NSUInteger)from and:(NSUInteger)to {
	return (NSUInteger) MIN([self clockwiseDistanceFrom:from to:to], [self counterClockwiseDistanceFrom:from to:to]);
}

@end
