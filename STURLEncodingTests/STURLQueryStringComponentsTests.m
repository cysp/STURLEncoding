//
//  STURLQueryStringComponentsTests.m
//  STURLEncoding
//
//  Copyright (c) 2013-2014 Scott Talbot. All rights reserved.
//

@import XCTest;

#import "STURLQueryStringComponents.h"
#import "STURLQueryStringEncoding.h"


@interface STURLQueryStringComponentsTests : XCTestCase
@end


@implementation STURLQueryStringComponentsTests

- (void)testSimple {
	{
		STMutableURLQueryStringComponents *components = [STMutableURLQueryStringComponents components];

		[components setString:nil forKey:@"a"];
		XCTAssertFalse([components containsKey:@"a"], @"");

		[components setString:@"" forKey:@"a"];
		XCTAssertTrue([components containsKey:@"a"], @"");

		[components removeStringsForKey:@"a"];
		XCTAssertFalse([components containsKey:@"a"], @"");
	}
}

- (void)testMutableCopy {
	{
		STMutableURLQueryStringComponents *a = [STMutableURLQueryStringComponents components];

		[a setString:@"a" forKey:@"a"];
		XCTAssertTrue([a containsKey:@"a"], @"");
		XCTAssertEqualObjects([a stringForKey:@"a"], @"a", @"");
		XCTAssertEqualObjects([a stringsForKey:@"a"], (@[ @"a" ]), @"");

		STURLQueryStringComponents *b = a.copy;
		XCTAssertTrue([b containsKey:@"a"], @"");
		XCTAssertEqualObjects([b stringForKey:@"a"], @"a", @"");
		XCTAssertEqualObjects([b stringsForKey:@"a"], (@[ @"a" ]), @"");

		STMutableURLQueryStringComponents *c = [b mutableCopy];
		XCTAssertTrue([c containsKey:@"a"], @"");
		XCTAssertEqualObjects([c stringForKey:@"a"], @"a", @"");
		XCTAssertEqualObjects([c stringsForKey:@"a"], (@[ @"a" ]), @"");

		[c removeStringsForKey:@"a"];
		XCTAssertFalse([c containsKey:@"a"], @"");
	}
}

- (void)testDictionaryConstructor {
	{
		NSDictionary * const input = @{ @"a": @"a" };
		STURLQueryStringComponents * const components = [STURLQueryStringComponents componentsWithDictionary:input];
		XCTAssertEqualObjects([components stringForKey:@"a"], @"a", @"");
	}
	{
		NSDictionary * const input = @{ @"a": @[ @"a" ] };
		STURLQueryStringComponents * const components = [STURLQueryStringComponents componentsWithDictionary:input];
		XCTAssertEqualObjects([components stringsForKey:@"a"], (@[ @"a" ]), @"");
		XCTAssertEqualObjects([components stringForKey:@"a"], @"a", @"");
	}
	{
		NSDictionary * const input = @{ @"a": @[ ] };
		STURLQueryStringComponents * const components = [STURLQueryStringComponents componentsWithDictionary:input];
		XCTAssertNotNil(components, @"");
		XCTAssertNil([components stringsForKey:@"a"], @"");
		XCTAssertNil([components stringForKey:@"a"], @"");
	}
	{
		NSDictionary * const input = @{ @"a": @(1) };
		STURLQueryStringComponents * const components = [STURLQueryStringComponents componentsWithDictionary:input];
		XCTAssertNil(components, @"");
	}
	{
		NSDictionary * const input = @{ @(1): @"a" };
		STMutableURLQueryStringComponents * const components = [STMutableURLQueryStringComponents componentsWithDictionary:input];
		XCTAssertNil(components, @"");
	}

	{
		NSDictionary * const input = @{ @"a": @"a" };
		STMutableURLQueryStringComponents * const components = [STMutableURLQueryStringComponents componentsWithDictionary:input];
		XCTAssertEqualObjects([components stringForKey:@"a"], @"a", @"");
		[components setString:@"b" forKey:@"a"];
		XCTAssertEqualObjects([components stringForKey:@"a"], @"b", @"");
	}

	{
		NSObject * const o = [[NSObject alloc] init];
		NSDictionary * const input = @{ @"a": o };
		STMutableURLQueryStringComponents * const components = [STMutableURLQueryStringComponents componentsWithDictionary:input];
		XCTAssertNil(components, @"");
	}

	{
		NSObject * const o = [[NSObject alloc] init];
		NSDictionary * const input = @{ @"a": @[ o ] };
		STMutableURLQueryStringComponents * const components = [STMutableURLQueryStringComponents componentsWithDictionary:input];
		XCTAssertNil(components, @"");
	}
}

- (void)testDictionaryRepresentation {
    {
        // Test basic case
        NSDictionary * const input = @{ @"a": @"a" };
        STURLQueryStringComponents * const components = [STURLQueryStringComponents componentsWithDictionary:input];
        NSDictionary * const output = [components dictionaryRepresentation];
        XCTAssertEqualObjects(input, output, @"");
    }
    {
        // Test array comes back as array
        NSString * const input = @"a=a&a=b";
        NSArray * const expected = @[@"a",@"b"];
        STURLQueryStringComponents * const components = [STURLQueryStringEncoding componentsFromQueryString:input];
        NSDictionary * const output = [components dictionaryRepresentation];
        XCTAssertEqual([output count], (NSUInteger)1, @"");
        XCTAssertEqualObjects(output[@"a"], expected, @"");
    }
    {
        // Test array comes back as only the first element if the STURLQueryStringComponentsDictionaryRepresentationDiscardDuplicates flag is set
        NSString * const input = @"a=a&a=b";
        STURLQueryStringComponents * const components = [STURLQueryStringEncoding componentsFromQueryString:input];
        NSDictionary * const output = [components dictionaryRepresentationWithOptions:STURLQueryStringComponentsDictionaryRepresentationUseFirstValue];
        XCTAssertEqual([output count], (NSUInteger)1, @"");
        XCTAssertEqualObjects(output[@"a"], @"a", @"");
    }
    {
        NSString * const input = @"a=a&b=";
        NSDictionary * const expected = @{@"a":@"a",@"b":@""};
        STURLQueryStringComponents * const components = [STURLQueryStringEncoding componentsFromQueryString:input];
        NSDictionary * const output = [components dictionaryRepresentation];
        XCTAssertEqualObjects(output, expected, @"");
    }
    {
        // Test more interesting dictionary
        NSDictionary * const input = @{ @"a":@"alex",
                                        @"b":@"bruce",
                                        @"c":@"cailin",
                                        @"d":@"dave",
                                        @"e":@"ethan" };
        STURLQueryStringComponents * const components = [STURLQueryStringComponents componentsWithDictionary:input];
        NSDictionary * const output = [components dictionaryRepresentation];
        XCTAssertEqualObjects(input, output, @"");
    }
}

@end
