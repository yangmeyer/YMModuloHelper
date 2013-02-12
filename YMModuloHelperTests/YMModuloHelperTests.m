
//  Created by Yang Meyer on 11.01.13.
//  Copyright (c) 2013 Yang Meyer. All rights reserved.

#import "YMModuloHelperTests.h"
#import "YMModuloHelper.h"

@implementation YMModuloHelperTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testSimpleDifference {
	YMModuloHelper *modulo = [YMModuloHelper moduloHelperWithCount:12];
	
	STAssertEquals([modulo distanceFrom:0 to:3 direction:YMModuloDirectionClockwise], (NSUInteger) 3, @"");
	STAssertEquals([modulo distanceFrom:0 to:6 direction:YMModuloDirectionClockwise], (NSUInteger) 6, @"");
	STAssertEquals([modulo distanceFrom:0 to:9 direction:YMModuloDirectionClockwise], (NSUInteger) 9, @"");
	STAssertEquals([modulo distanceFrom:0 to:11 direction:YMModuloDirectionClockwise], (NSUInteger) 11, @"");
	
	STAssertEquals([modulo distanceFrom:6 to:3 direction:YMModuloDirectionCounterClockwise], (NSUInteger) 3, @"");
	STAssertEquals([modulo distanceFrom:6 to:0 direction:YMModuloDirectionCounterClockwise], (NSUInteger) 6, @"");
}

- (void)testDifferenceCrossingZero {
	YMModuloHelper *modulo = [YMModuloHelper moduloHelperWithCount:12];
	
	STAssertEquals([modulo distanceFrom:9 to:0 direction:YMModuloDirectionClockwise], (NSUInteger) 3, @"");
	STAssertEquals([modulo distanceFrom:9 to:3 direction:YMModuloDirectionClockwise], (NSUInteger) 6, @"");
	STAssertEquals([modulo distanceFrom:9 to:6 direction:YMModuloDirectionClockwise], (NSUInteger) 9, @"");
	STAssertEquals([modulo distanceFrom:9 to:8 direction:YMModuloDirectionClockwise], (NSUInteger) 11, @"");
	
	STAssertEquals([modulo distanceFrom:3 to:0 direction:YMModuloDirectionCounterClockwise], (NSUInteger) 3, @"");
	STAssertEquals([modulo distanceFrom:3 to:9 direction:YMModuloDirectionCounterClockwise], (NSUInteger) 6, @"");
	STAssertEquals([modulo distanceFrom:3 to:6 direction:YMModuloDirectionCounterClockwise], (NSUInteger) 9, @"");
	
	STAssertEquals([modulo distanceFrom:0 to:3 direction:YMModuloDirectionShortest], (NSUInteger) 3, @"");
	STAssertEquals([modulo distanceFrom:3 to:0 direction:YMModuloDirectionShortest], (NSUInteger) 3, @"");
	
	STAssertEquals([modulo distanceFrom:6 to:0 direction:YMModuloDirectionShortest], (NSUInteger) 6, @"");
	STAssertEquals([modulo distanceFrom:0 to:6 direction:YMModuloDirectionShortest], (NSUInteger) 6, @"");
}

- (void)testModulo2 {
	YMModuloHelper *modulo = [YMModuloHelper moduloHelperWithCount:2];
	STAssertEquals([modulo distanceFrom:0 to:1 direction:YMModuloDirectionClockwise], (NSUInteger) 1, @"");
	STAssertEquals([modulo distanceFrom:1 to:0 direction:YMModuloDirectionClockwise], (NSUInteger) 1, @"");
	
	STAssertEquals([modulo distanceFrom:1 to:1 direction:YMModuloDirectionClockwise], (NSUInteger) 0, @"");
	STAssertEquals([modulo distanceFrom:1 to:1 direction:YMModuloDirectionShortest], (NSUInteger) 0, @"");
}

- (void)testNormalization {
	YMModuloHelper *modulo = [YMModuloHelper moduloHelperWithCount:10];
	STAssertEquals([modulo normalizedIndex:0], (NSUInteger) 0, @"");
	STAssertEquals([modulo normalizedIndex:3], (NSUInteger) 3, @"");
	STAssertEquals([modulo normalizedIndex:10], (NSUInteger) 0, @"");
	STAssertEquals([modulo normalizedIndex:15], (NSUInteger) 5, @"");
	STAssertEquals([modulo normalizedIndex:27], (NSUInteger) 7, @"");
}

- (void)testEnumeration {
	YMModuloHelper *modulo = [YMModuloHelper moduloHelperWithCount:12];
	
	NSMutableArray *indexes = [NSMutableArray arrayWithCapacity:modulo.count*2];
	[modulo enumerateIndexesFrom:2 through:6 withBlock:^(NSUInteger idx) {
		[indexes addObject:@(idx)];
	} direction:YMModuloDirectionShortest];
	STAssertEqualObjects([indexes componentsJoinedByString:@","], @"2,3,4,5,6", @"");
}

- (void)testEnumerationWithDistanceZero {
	YMModuloHelper *modulo = [YMModuloHelper moduloHelperWithCount:12];
	
	NSMutableArray *indexes = [NSMutableArray arrayWithCapacity:modulo.count*2];
	[modulo enumerateIndexesFrom:2 through:2 withBlock:^(NSUInteger idx) {
		[indexes addObject:@(idx)];
	} direction:YMModuloDirectionShortest];
	STAssertEqualObjects([indexes componentsJoinedByString:@","], @"2", @"");
}

- (void)testEnumerationWithDistanceOne {
	YMModuloHelper *modulo = [YMModuloHelper moduloHelperWithCount:12];
	
	// clockwise
	NSMutableArray *indexes = [NSMutableArray arrayWithCapacity:modulo.count*2];
	[modulo enumerateIndexesFrom:2 through:3 withBlock:^(NSUInteger idx) {
		[indexes addObject:@(idx)];
	} direction:YMModuloDirectionShortest];
	STAssertEqualObjects([indexes componentsJoinedByString:@","], @"2,3", @"");
	
	// counter-clockwise
	indexes = [NSMutableArray arrayWithCapacity:modulo.count*2];
	[modulo enumerateIndexesFrom:3 through:2 withBlock:^(NSUInteger idx) {
		[indexes addObject:@(idx)];
	} direction:YMModuloDirectionShortest];
	STAssertEqualObjects([indexes componentsJoinedByString:@","], @"3,2", @"");
}

#pragma mark - Nearest

- (void)testNearestClockwiseIndex {
	YMModuloHelper *modulo = [YMModuloHelper moduloHelperWithCount:12];
	
	NSMutableIndexSet *candidates = [NSMutableIndexSet indexSetWithIndex:10];
	STAssertEquals([modulo nearestIndexOfCandidates:candidates clockwiseFrom:4], (NSUInteger) 10, @"Opposite can very well be nearest!");
	
	[candidates addIndex:0];
	STAssertEquals([modulo nearestIndexOfCandidates:candidates clockwiseFrom:4], (NSUInteger) 10, @"Zero is nearer than 10, but only counter-clockwise");
	
	[candidates addIndex:5];
	STAssertEquals([modulo nearestIndexOfCandidates:candidates clockwiseFrom:4], (NSUInteger) 5, @"Simple clockwise");
	
	[candidates addIndex:4];
	STAssertEquals([modulo nearestIndexOfCandidates:candidates clockwiseFrom:4], (NSUInteger) 4, @"Already there!");
}


- (void)testNearestCounterClockwiseIndex {
	YMModuloHelper *modulo = [YMModuloHelper moduloHelperWithCount:12];
	
	NSMutableIndexSet *candidates = [NSMutableIndexSet indexSetWithIndex:5];
	STAssertEquals([modulo nearestIndexOfCandidates:candidates counterClockwiseFrom:4], (NSUInteger) 5, @"The 'clockwise-next' index has the maximum distance but still can be the nearest");
	
	[candidates addIndex:10];
	STAssertEquals([modulo nearestIndexOfCandidates:candidates counterClockwiseFrom:4], (NSUInteger) 10, @"Opposite can very well be nearest!");
	
	[candidates addIndex:3];
	STAssertEquals([modulo nearestIndexOfCandidates:candidates counterClockwiseFrom:4], (NSUInteger) 3, @"Simple counter-clockwise");
	
	[candidates addIndex:4];
	STAssertEquals([modulo nearestIndexOfCandidates:candidates counterClockwiseFrom:4], (NSUInteger) 4, @"Already there!");
}

- (void)testNearestIndex {
	YMModuloHelper *modulo = [YMModuloHelper moduloHelperWithCount:12];
	
	NSMutableIndexSet *candidates = [NSMutableIndexSet indexSetWithIndex:10];
	STAssertEquals([modulo nearestIndexOfCandidates:candidates from:4], (NSUInteger) 10, @"Opposite can very well be nearest!");
	
	[candidates addIndex:11];
	STAssertEquals([modulo nearestIndexOfCandidates:candidates from:4], (NSUInteger) 11, @"Counter-clockwise crossing zero");
	
	[candidates addIndex:0];
	STAssertEquals([modulo nearestIndexOfCandidates:candidates from:4], (NSUInteger) 0, @"Zero can be nearest");
	
	[candidates addIndex:2];
	STAssertEquals([modulo nearestIndexOfCandidates:candidates from:4], (NSUInteger) 2, @"Simple counter-clockwise");
	
	[candidates addIndex:5];
	STAssertEquals([modulo nearestIndexOfCandidates:candidates from:4], (NSUInteger) 5, @"Simple clockwise");
	
	[candidates addIndex:4];
	STAssertEquals([modulo nearestIndexOfCandidates:candidates from:4], (NSUInteger) 4, @"Already there!");
}

@end
