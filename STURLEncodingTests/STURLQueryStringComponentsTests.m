//
//  STURLQueryStringComponentsTests.m
//  STURLEncoding
//
//  Copyright (c) 2013 Scott Talbot. All rights reserved.
//

#import "STURLQueryStringComponentsTests.h"

#import "STURLQueryStringComponents.h"


@implementation STURLQueryStringComponentsTests

- (void)testSimple {
	{
		STMutableURLQueryStringComponents *components = [STMutableURLQueryStringComponents components];

		[components setString:nil forKey:@"a"];
		STAssertFalse([components containsKey:@"a"], @"", nil);

		[components setString:@"" forKey:@"a"];
		STAssertTrue([components containsKey:@"a"], @"", nil);

		[components removeStringsForKey:@"a"];
		STAssertFalse([components containsKey:@"a"], @"", nil);
	}

	{
		STMutableURLQueryStringComponents *components = [STMutableURLQueryStringComponents components];
		[components addString:nil forKey:@"a"];
		STAssertFalse([components containsKey:@"a"], @"", nil);
	}
}

- (void)testMutableCopy {
	{
		STMutableURLQueryStringComponents *a = [STMutableURLQueryStringComponents components];

		[a setString:@"a" forKey:@"a"];
		STAssertTrue([a containsKey:@"a"], @"", nil);
		STAssertEqualObjects([a stringForKey:@"a"], @"a", @"", nil);
		STAssertEqualObjects([a stringsForKey:@"a"], (@[ @"a" ]), @"", nil);

		STURLQueryStringComponents *b = [a copy];
		STAssertTrue([b containsKey:@"a"], @"", nil);
		STAssertEqualObjects([b stringForKey:@"a"], @"a", @"", nil);
		STAssertEqualObjects([b stringsForKey:@"a"], (@[ @"a" ]), @"", nil);

		STMutableURLQueryStringComponents *c = [b mutableCopy];
		STAssertTrue([c containsKey:@"a"], @"", nil);
		STAssertEqualObjects([c stringForKey:@"a"], @"a", @"", nil);
		STAssertEqualObjects([c stringsForKey:@"a"], (@[ @"a" ]), @"", nil);

		[c removeStringsForKey:@"a"];
		STAssertFalse([c containsKey:@"a"], @"", nil);
	}
}

- (void)testDictionaryConstructor {
	{
		NSDictionary * const input = @{ @"a": @"a" };
		STURLQueryStringComponents * const components = [STURLQueryStringComponents componentsWithDictionary:input];
		STAssertEqualObjects([components stringForKey:@"a"], @"a", @"", nil);
	}
	{
		NSDictionary * const input = @{ @"a": @[ @"a" ] };
		STURLQueryStringComponents * const components = [STURLQueryStringComponents componentsWithDictionary:input];
		STAssertNil(components, @"", nil);
	}
	{
		NSDictionary * const input = @{ @"a": @(1) };
		STURLQueryStringComponents * const components = [STURLQueryStringComponents componentsWithDictionary:input];
		STAssertNil(components, @"", nil);
	}

	{
		NSDictionary * const input = @{ @"a": @"a" };
		STMutableURLQueryStringComponents * const components = [STMutableURLQueryStringComponents componentsWithDictionary:input];
		STAssertEqualObjects([components stringForKey:@"a"], @"a", @"", nil);
		[components setString:@"b" forKey:@"a"];
		STAssertEqualObjects([components stringForKey:@"a"], @"b", @"", nil);
	}
}

@end
