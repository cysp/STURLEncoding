//
//  STURLQueryStringComponentsTests.m
//  STURLEncoding
//
//  Copyright (c) 2013 Scott Talbot. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import "STURLQueryStringComponents.h"
#import "STURLQueryStringEncoding.h"


@interface STURLQueryStringComponentsTests : SenTestCase
@end


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
		STAssertEqualObjects([components stringsForKey:@"a"], (@[ @"a" ]), @"", nil);
		STAssertEqualObjects([components stringForKey:@"a"], @"a", @"", nil);
	}
	{
		NSDictionary * const input = @{ @"a": @[ ] };
		STURLQueryStringComponents * const components = [STURLQueryStringComponents componentsWithDictionary:input];
		STAssertNotNil(components, @"", nil);
		STAssertNil([components stringsForKey:@"a"], @"", nil);
		STAssertNil([components stringForKey:@"a"], @"", nil);
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

- (void)testDictionaryRepresentation {
    {
        // Test basic case
        NSDictionary * const input = @{ @"a": @"a" };
        STURLQueryStringComponents * const components = [STURLQueryStringComponents componentsWithDictionary:input];
        NSDictionary * const output = [components dictionaryRepresentation];
        STAssertEqualObjects(input, output, @"");
    }
    {
        // Test array comes back as array
        NSString * const input = @"a=a&a=b";
        NSArray * const expected = @[@"a",@"b"];
        STURLQueryStringComponents * const components = [STURLQueryStringEncoding componentsFromQueryString:input];
        NSDictionary * const output = [components dictionaryRepresentation];
        STAssertEquals([output count], (NSUInteger)1, @"");
        STAssertEqualObjects(output[@"a"], expected, @"");
    }
    {
        // Test array comes back as only the first element if the STURLQueryStringComponentsDictionaryRepresentationDiscardDuplicates flag is set
        NSString * const input = @"a=a&a=b";
        STURLQueryStringComponents * const components = [STURLQueryStringEncoding componentsFromQueryString:input];
        NSDictionary * const output = [components dictionaryRepresentationWithOptions:STURLQueryStringComponentsDictionaryRepresentationUseFirstValue];
        STAssertEquals([output count], (NSUInteger)1, @"");
        STAssertEqualObjects(output[@"a"], @"a", @"");
    }
    {
        NSString * const input = @"a=a&b=";
        NSDictionary * const expected = @{@"a":@"a",@"b":@""};
        STURLQueryStringComponents * const components = [STURLQueryStringEncoding componentsFromQueryString:input];
        NSDictionary * const output = [components dictionaryRepresentation];
        STAssertEqualObjects(output, expected, @"");
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
        STAssertEqualObjects(input, output, @"");
    }
}

@end
