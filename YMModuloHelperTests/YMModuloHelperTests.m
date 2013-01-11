
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

@end
