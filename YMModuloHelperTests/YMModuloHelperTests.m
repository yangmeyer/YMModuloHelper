
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
	
	STAssertEquals([modulo clockwiseDistanceFrom:0 to:3], (NSUInteger) 3, @"");
	STAssertEquals([modulo clockwiseDistanceFrom:0 to:6], (NSUInteger) 6, @"");
	STAssertEquals([modulo clockwiseDistanceFrom:0 to:9], (NSUInteger) 9, @"");
	STAssertEquals([modulo clockwiseDistanceFrom:0 to:11], (NSUInteger) 11, @"");
	
	STAssertEquals([modulo counterClockwiseDistanceFrom:6 to:3], (NSUInteger) 3, @"");
	STAssertEquals([modulo counterClockwiseDistanceFrom:6 to:0], (NSUInteger) 6, @"");
}

- (void)testDifferenceCrossingZero {
	YMModuloHelper *modulo = [YMModuloHelper moduloHelperWithCount:12];
	
	STAssertEquals([modulo clockwiseDistanceFrom:9 to:0], (NSUInteger) 3, @"");
	STAssertEquals([modulo clockwiseDistanceFrom:9 to:3], (NSUInteger) 6, @"");
	STAssertEquals([modulo clockwiseDistanceFrom:9 to:6], (NSUInteger) 9, @"");
	STAssertEquals([modulo clockwiseDistanceFrom:9 to:8], (NSUInteger) 11, @"");
	
	STAssertEquals([modulo counterClockwiseDistanceFrom:3 to:0], (NSUInteger) 3, @"");
	STAssertEquals([modulo counterClockwiseDistanceFrom:3 to:9], (NSUInteger) 6, @"");
	STAssertEquals([modulo counterClockwiseDistanceFrom:3 to:6], (NSUInteger) 9, @"");
	
	STAssertEquals([modulo shortestDistanceBetween:0 and:3], (NSUInteger) 3, @"");
	STAssertEquals([modulo shortestDistanceBetween:3 and:0], (NSUInteger) 3, @"");
	
	STAssertEquals([modulo shortestDistanceBetween:6 and:0], (NSUInteger) 6, @"");
	STAssertEquals([modulo shortestDistanceBetween:0 and:6], (NSUInteger) 6, @"");
}

- (void)testModulo2 {
	YMModuloHelper *modulo = [YMModuloHelper moduloHelperWithCount:2];
	STAssertEquals([modulo clockwiseDistanceFrom:0 to:1], (NSUInteger) 1, @"");
	STAssertEquals([modulo clockwiseDistanceFrom:1 to:0], (NSUInteger) 1, @"");
	
	STAssertEquals([modulo clockwiseDistanceFrom:1 to:1], (NSUInteger) 0, @"");
	STAssertEquals([modulo shortestDistanceBetween:1 and:1], (NSUInteger) 0, @"");
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
	[modulo enumerateIndexesOnShortestPathFrom:2 through:6 withBlock:^(NSUInteger idx) {
		[indexes addObject:@(idx)];
	}];
	STAssertEqualObjects([indexes componentsJoinedByString:@","], @"2,3,4,5,6", @"");
}

- (void)testEnumerationWithDistanceZero {
	YMModuloHelper *modulo = [YMModuloHelper moduloHelperWithCount:12];
	
	NSMutableArray *indexes = [NSMutableArray arrayWithCapacity:modulo.count*2];
	[modulo enumerateIndexesOnShortestPathFrom:2 through:2 withBlock:^(NSUInteger idx) {
		[indexes addObject:@(idx)];
	}];
	STAssertEqualObjects([indexes componentsJoinedByString:@","], @"2", @"");
}

- (void)testEnumerationWithDistanceOne {
	YMModuloHelper *modulo = [YMModuloHelper moduloHelperWithCount:12];
	
	// clockwise
	NSMutableArray *indexes = [NSMutableArray arrayWithCapacity:modulo.count*2];
	[modulo enumerateIndexesOnShortestPathFrom:2 through:3 withBlock:^(NSUInteger idx) {
		[indexes addObject:@(idx)];
	}];
	STAssertEqualObjects([indexes componentsJoinedByString:@","], @"2,3", @"");
	
	// counter-clockwise
	indexes = [NSMutableArray arrayWithCapacity:modulo.count*2];
	[modulo enumerateIndexesOnShortestPathFrom:3 through:2 withBlock:^(NSUInteger idx) {
		[indexes addObject:@(idx)];
	}];
	STAssertEqualObjects([indexes componentsJoinedByString:@","], @"3,2", @"");
}

- (void)testNearestIndex {
	YMModuloHelper *modulo = [YMModuloHelper moduloHelperWithCount:12];
	
	NSMutableIndexSet *candidates = [NSMutableIndexSet indexSetWithIndex:10];
	STAssertEquals([modulo nearestIndexFrom:4 candidates:candidates], (NSUInteger) 10, @"Opposite can very well be nearest!");
	
	[candidates addIndex:11];
	STAssertEquals([modulo nearestIndexFrom:4 candidates:candidates], (NSUInteger) 11, @"Counter-clockwise crossing zero");
	
	[candidates addIndex:0];
	STAssertEquals([modulo nearestIndexFrom:4 candidates:candidates], (NSUInteger) 0, @"Zero can be nearest");
	
	[candidates addIndex:2];
	STAssertEquals([modulo nearestIndexFrom:4 candidates:candidates], (NSUInteger) 2, @"Simple counter-clockwise");
	
	[candidates addIndex:5];
	STAssertEquals([modulo nearestIndexFrom:4 candidates:candidates], (NSUInteger) 5, @"Simple clockwise");
	
	[candidates addIndex:4];
	STAssertEquals([modulo nearestIndexFrom:4 candidates:candidates], (NSUInteger) 4, @"Already there!");
}

@end
