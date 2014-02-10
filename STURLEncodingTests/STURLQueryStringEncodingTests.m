//
//  STURLQueryStringEncodingTests.m
//  STURLEncoding
//
//  Copyright (c) 2012-2014 Scott Talbot. All rights reserved.
//

@import XCTest;

#import "STURLQueryStringEncoding.h"


@interface STURLQueryStringEncodingTests : XCTestCase
@end


@implementation STURLQueryStringEncodingTests

- (void)testSimple {
	{
		STMutableURLQueryStringComponents *components = [STMutableURLQueryStringComponents components];

		[components setString:nil forKey:@"a"];
		XCTAssertFalse([components containsKey:@"a"], @"");
		{
			NSString *queryString = [STURLQueryStringEncoding queryStringFromComponents:components];
			XCTAssertEqualObjects(queryString, @"", @"");
		}

		[components setString:@"" forKey:@"a"];
		XCTAssertTrue([components containsKey:@"a"], @"");
		{
			NSString *queryString = [STURLQueryStringEncoding queryStringFromComponents:components];
			XCTAssertEqualObjects(queryString, @"a=", @"");
		}

		[components removeStringsForKey:@"a"];
		XCTAssertFalse([components containsKey:@"a"], @"");
		{
			NSString *queryString = [STURLQueryStringEncoding queryStringFromComponents:components];
			XCTAssertEqualObjects(queryString, @"", @"");
		}
	}
	{
		STMutableURLQueryStringComponents *components = [STMutableURLQueryStringComponents components];
		[components addString:nil forKey:@"a"];
		XCTAssertFalse([components containsKey:@"a"], @"");
	}
}

- (void)testQueryStringBuilding {
	{
		STMutableURLQueryStringComponents *components = [STMutableURLQueryStringComponents components];
		[components setString:@"bar" forKey:@"foo"];
		XCTAssertTrue([components containsKey:@"foo"], @"");
		XCTAssertEqualObjects([components stringForKey:@"foo"], @"bar", @"");
		NSString *queryString = [STURLQueryStringEncoding queryStringFromComponents:components];
		XCTAssertEqualObjects(queryString, @"foo=bar", @"");
	}
	{
		STMutableURLQueryStringComponents *components = [STMutableURLQueryStringComponents components];
		[components setString:@"bar" forKey:@"foo"];
		[components addString:@"baz" forKey:@"foo"];
		XCTAssertTrue([components containsKey:@"foo"], @"");
		XCTAssertEqualObjects([components stringForKey:@"foo"], @"bar", @"");
		NSArray *foo = @[ @"bar", @"baz" ];
		XCTAssertEqualObjects([components stringsForKey:@"foo"], foo, @"");
		NSString *queryString = [STURLQueryStringEncoding queryStringFromComponents:components];
		XCTAssertEqualObjects(queryString, @"foo[]=bar&foo[]=baz", @"");
	}
	{
		STMutableURLQueryStringComponents *components = [STMutableURLQueryStringComponents components];
		[components setString:@"bar" forKey:@"foo"];
		[components setString:@"AAA" forKey:@"aaa"];
		XCTAssertTrue([components containsKey:@"foo"], @"");
		XCTAssertEqualObjects([components stringForKey:@"foo"], @"bar", @"");
		NSString *queryString = [STURLQueryStringEncoding queryStringFromComponents:components];
		XCTAssertEqualObjects(queryString, @"aaa=AAA&foo=bar", @"");
	}
	{
		STMutableURLQueryStringComponents *components = [STMutableURLQueryStringComponents components];
		[components setString:@"b?r" forKey:@"foo"];
		[components setString:@"A&A" forKey:@"aaa"];
		XCTAssertTrue([components containsKey:@"foo"], @"");
		XCTAssertEqualObjects([components stringForKey:@"foo"], @"b?r", @"");
		NSString *queryString = [STURLQueryStringEncoding queryStringFromComponents:components];
		XCTAssertEqualObjects(queryString, @"aaa=A%26A&foo=b%3Fr", @"");
	}
    {
        STMutableURLQueryStringComponents *components = [STMutableURLQueryStringComponents components];
        components[@"foo"] = @[@"bar",@"baz"];
        components[@"aaa"] = @"AAA";
        components[@"bbb"] = @"BBB";
        components[@"bbb"] = nil;
		XCTAssertTrue([components containsKey:@"foo"], @"");
		XCTAssertEqualObjects([components stringForKey:@"foo"], @"bar", @"");
		NSArray *foo = @[ @"bar", @"baz" ];
		XCTAssertEqualObjects([components stringsForKey:@"foo"], foo, @"");
        XCTAssertTrue([components containsKey:@"aaa"], @"");
        XCTAssertFalse([components containsKey:@"bbb"], @"");
		NSString *queryString = [STURLQueryStringEncoding queryStringFromComponents:components];
		XCTAssertEqualObjects(queryString, @"aaa=AAA&foo[]=bar&foo[]=baz", @"");
    }
}

- (void)testQueryString {
	{
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"foo"];
		XCTAssertNotNil(components, @"error decoding query string");
		XCTAssertTrue([components containsKey:@"foo"], @"");
		XCTAssertFalse([components containsKey:@"bar"], @"");
		XCTAssertEqualObjects([components stringForKey:@"foo"], @"", @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"foo" error:&error];
		XCTAssertNotNil(components, @"error decoding query string: %@", error);
		XCTAssertTrue([components containsKey:@"foo"], @"");
		XCTAssertFalse([components containsKey:@"bar"], @"");
		XCTAssertEqualObjects([components stringForKey:@"foo"], @"", @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"foo=" error:&error];
		XCTAssertNotNil(components, @"error decoding query string: %@", error);
		XCTAssertTrue([components containsKey:@"foo"], @"");
		XCTAssertFalse([components containsKey:@"bar"], @"");
		XCTAssertEqualObjects([components stringForKey:@"foo"], @"", @"");
		XCTAssertEqualObjects(components[@"foo"], @"", @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"foo&bar" error:&error];
		XCTAssertNotNil(components, @"error decoding query string: %@", error);
		XCTAssertTrue([components containsKey:@"foo"], @"");
		XCTAssertTrue([components containsKey:@"bar"], @"");
		XCTAssertEqualObjects([components stringForKey:@"foo"], @"", @"");
		XCTAssertEqualObjects([components stringForKey:@"bar"], @"", @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"foo=baz&bar" error:&error];
		XCTAssertNotNil(components, @"error decoding query string: %@", error);
		XCTAssertTrue([components containsKey:@"foo"], @"");
		XCTAssertEqualObjects(components[@"foo"], @"baz", @"");
		XCTAssertEqualObjects([components stringForKey:@"foo"], @"baz", @"");
		XCTAssertEqualObjects([components stringsForKey:@"foo"], @[ @"baz" ], @"");
		XCTAssertTrue([components containsKey:@"bar"], @"");
		XCTAssertEqualObjects([components stringForKey:@"bar"], @"", @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"foo=baz&bar=" error:&error];
		XCTAssertNotNil(components, @"error decoding query string: %@", error);
		XCTAssertTrue([components containsKey:@"foo"], @"");
		XCTAssertEqualObjects(components[@"foo"], @"baz", @"");
		XCTAssertEqualObjects([components stringForKey:@"foo"], @"baz", @"");
		XCTAssertEqualObjects([components stringsForKey:@"foo"], @[ @"baz" ], @"");
		XCTAssertTrue([components containsKey:@"bar"], @"");
		XCTAssertEqualObjects(components[@"bar"], @"", @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"foo=baz&;&bar=" error:&error];
		XCTAssertNotNil(components, @"error decoding query string: %@", error);
		XCTAssertTrue([components containsKey:@"foo"], @"");
		XCTAssertEqualObjects(components[@"foo"], @"baz", @"");
		XCTAssertEqualObjects([components stringForKey:@"foo"], @"baz", @"");
		XCTAssertEqualObjects([components stringsForKey:@"foo"], @[ @"baz" ], @"");
		XCTAssertTrue([components containsKey:@"bar"], @"");
		XCTAssertEqualObjects(components[@"bar"], @"", @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"foo=baz&bar=&" error:&error];
		XCTAssertNotNil(components, @"error decoding query string: %@", error);
		XCTAssertTrue([components containsKey:@"foo"], @"");
		XCTAssertEqualObjects(components[@"foo"], @"baz", @"");
		XCTAssertEqualObjects([components stringForKey:@"foo"], @"baz", @"");
		XCTAssertEqualObjects([components stringsForKey:@"foo"], @[ @"baz" ], @"");
		XCTAssertTrue([components containsKey:@"bar"], @"");
		XCTAssertEqualObjects(components[@"bar"], @"", @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"foo=baz&bar=quux" error:&error];
		XCTAssertNotNil(components, @"error decoding query string: %@", error);
		XCTAssertTrue([components containsKey:@"foo"], @"");
		XCTAssertEqualObjects(components[@"foo"], @"baz", @"");
		XCTAssertTrue([components containsKey:@"bar"], @"");
		XCTAssertEqualObjects(components[@"bar"], @"quux", @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"foo&bar=quuux" error:&error];
		XCTAssertNotNil(components, @"error decoding query string: %@", error);
		XCTAssertTrue([components containsKey:@"foo"], @"");
		XCTAssertTrue([components containsKey:@"bar"], @"");
		XCTAssertEqualObjects(components[@"bar"], @"quuux", @"");
		XCTAssertEqualObjects([components stringForKey:@"foo"], @"", @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"foo&bar=qu%20uux" error:&error];
		XCTAssertNotNil(components, @"error decoding query string: %@", error);
		XCTAssertTrue([components containsKey:@"foo"], @"");
		XCTAssertTrue([components containsKey:@"bar"], @"");
		XCTAssertEqualObjects(components[@"bar"], @"qu uux", @"");
		XCTAssertEqualObjects([components stringForKey:@"foo"], @"", @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"f%26oo&bar=qu%20uux" error:&error];
		XCTAssertNotNil(components, @"error decoding query string: %@", error);
		XCTAssertTrue([components containsKey:@"f&oo"], @"");
		XCTAssertTrue([components containsKey:@"bar"], @"");
		XCTAssertEqualObjects(components[@"bar"], @"qu uux", @"");
		XCTAssertEqualObjects([components stringForKey:@"f&oo"], @"", @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"f%26oo;bar=qu%20uux" error:&error];
		XCTAssertNotNil(components, @"error decoding query string: %@", error);
		XCTAssertTrue([components containsKey:@"f&oo"], @"");
		XCTAssertTrue([components containsKey:@"bar"], @"");
		XCTAssertEqualObjects(components[@"bar"], @"qu uux", @"");
		XCTAssertEqualObjects([components stringForKey:@"f&oo"], @"", @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"f+oo;bar=qu%20uux" error:&error];
		XCTAssertNotNil(components, @"error decoding query string: %@", error);
		XCTAssertTrue([components containsKey:@"f oo"], @"");
		XCTAssertTrue([components containsKey:@"bar"], @"");
		XCTAssertEqualObjects([components stringForKey:@"f oo"], @"", @"");
		XCTAssertEqualObjects(components[@"bar"], @"qu uux", @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"f+oo;bar=qu%20u+ux" error:&error];
		XCTAssertNotNil(components, @"error decoding query string: %@", error);
		XCTAssertTrue([components containsKey:@"f oo"], @"");
		XCTAssertTrue([components containsKey:@"bar"], @"");
		XCTAssertEqualObjects([components stringForKey:@"f oo"], @"", @"");
		XCTAssertEqualObjects(components[@"bar"], @"qu u ux", @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"foo=qu%20uux&foo=" error:&error];
		XCTAssertNotNil(components, @"error decoding query string: %@", error);
		XCTAssertTrue([components containsKey:@"foo"], @"");
		NSArray *expected = @[ @"qu uux", @"" ];
		XCTAssertEqualObjects(components[@"foo"], expected, @"");
		XCTAssertEqualObjects([components stringsForKey:@"foo"], expected, @"");
		XCTAssertEqualObjects([components stringForKey:@"foo"], @"qu uux", @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"foo[]=;foo[]=qu%20uux&foo[]=" error:&error];
		XCTAssertNotNil(components, @"error decoding query string: %@", error);
		XCTAssertTrue([components containsKey:@"foo"], @"");
		NSArray *expected = @[ @"", @"qu uux", @"" ];
		XCTAssertEqualObjects(components[@"foo"], expected, @"");
		XCTAssertEqualObjects([components stringsForKey:@"foo"], expected, @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"fo/o[]=;foo[]=qu%20uux&foo[]=" error:&error];
		XCTAssertNotNil(components, @"error decoding query string: %@", error);
		XCTAssertTrue([components containsKey:@"foo"], @"");
		XCTAssertTrue([components containsKey:@"fo/o"], @"");
		XCTAssertEqualObjects(components[@"fo/o"], @"", @"");
		{
			NSArray *expected = @[ @"qu uux", @"" ];
			XCTAssertEqualObjects(components[@"foo"], expected, @"");
			XCTAssertEqualObjects([components stringsForKey:@"foo"], expected, @"");
		}
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"foo[]=;foo[]=qu%20u/ux&foo[]=" error:&error];
		XCTAssertNotNil(components, @"error decoding query string: %@", error);
		XCTAssertTrue([components containsKey:@"foo"], @"");
		NSArray *expected = @[ @"", @"qu u/ux", @"" ];
		XCTAssertEqualObjects(components[@"foo"], expected, @"");
		XCTAssertEqualObjects([components stringsForKey:@"foo"], expected, @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"fo?o[]=;foo[]=qu%20uux&foo[]=" error:&error];
		XCTAssertNotNil(components, @"error decoding query string: %@", error);
		XCTAssertTrue([components containsKey:@"foo"], @"");
		XCTAssertTrue([components containsKey:@"fo?o"], @"");
		XCTAssertEqualObjects(components[@"fo?o"], @"", @"");
		{
			NSArray *expected = @[ @"qu uux", @"" ];
			XCTAssertEqualObjects(components[@"foo"], expected, @"");
			XCTAssertEqualObjects([components stringsForKey:@"foo"], expected, @"");
		}
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"foo[]=;foo[]=qu%20u?ux&foo[]=" error:&error];
		XCTAssertNotNil(components, @"error decoding query string: %@", error);
		XCTAssertTrue([components containsKey:@"foo"], @"");
		NSArray *expected = @[ @"", @"qu u?ux", @"" ];
		XCTAssertEqualObjects(components[@"foo"], expected, @"");
		XCTAssertEqualObjects([components stringsForKey:@"foo"], expected, @"");
	}
}

- (void)testQueryStringDecodingFailures {
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"" error:&error];
		XCTAssertNotNil(components, @"%@", error);
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"=" error:&error];
		XCTAssertNil(components, @"%@", error);
		XCTAssertNotNil(error, @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"&=" error:&error];
		XCTAssertNil(components, @"%@", error);
		XCTAssertNotNil(error, @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"a=%" error:&error];
		XCTAssertNil(components, @"%@", error);
		XCTAssertNotNil(error, @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"a%=%" error:&error];
		XCTAssertNil(components, @"%@", error);
		XCTAssertNotNil(error, @"");
	}
}

@end
