//
//  STURLEncodingTests.m
//  STURLEncodingTests
//
//  Copyright (c) 2012 Scott Talbot. All rights reserved.
//

#import "STURLEncodingTests.h"

#import "STURLEncoding.h"


@implementation STURLEncodingTests {
	NSArray *_urlEncodingTable;
}

- (void)setUp {
	_urlEncodingTable = @[
		@[ @"", @"" ],
		@[ @"abcABC123", @"abcABC123" ],
		@[ @"-._~", @"-._~" ],
		@[ @"%", @"%25" ],
		@[ @"+", @"%2B" ],
		@[ @"&=*", @"%26%3D%2A" ],
		@[ @"\n", @"%0A" ],
		@[ @" ", @"%20", ],
		@[ @"\x7f", @"%7F" ],
//		@[ @"\x80", @"%C2%80" ], // disabled due to NSString input validation
		@[ @"\u3001", @"%E3%80%81" ],
	];
}

- (void)tearDown {
	_urlEncodingTable = nil;
}

- (void)testURLEncoding {
	STAssertNotNil(_urlEncodingTable, @"");

	for (NSArray *testcase in _urlEncodingTable) {
		NSString *input = testcase[0];
		NSString *expected = testcase[1];
		NSString *output = [STURLEncoding stringByURLEncodingString:input];
		STAssertNotNil(output, @"error encoding");
		STAssertEqualObjects(output, expected, @"encoding output doesn't match expected");
	}
}

- (void)testURLDecoding {
	STAssertNotNil(_urlEncodingTable, @"");

	for (NSArray *testcase in _urlEncodingTable) {
		NSString *input = testcase[1];
		NSString *expected = testcase[0];
		NSString *output = [STURLEncoding stringByURLDecodingString:input];
		STAssertNotNil(output, @"error decoding");
		STAssertEqualObjects(output, expected, @"decoding output doesn't match expected");
	}
}


- (void)testQueryString {
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLEncoding componentsFromQueryString:@"foo" error:&error];
		STAssertNotNil(components, @"error decoding query string: %@", error);
		STAssertTrue([components containsKey:@"foo"], @"");
		STAssertFalse([components containsKey:@"bar"], @"");
		STAssertNil([components stringForKey:@"foo"], @"");
		STAssertNil(components[@"foo"], @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLEncoding componentsFromQueryString:@"foo=" error:&error];
		STAssertNotNil(components, @"error decoding query string: %@", error);
		STAssertTrue([components containsKey:@"foo"], @"");
		STAssertFalse([components containsKey:@"bar"], @"");
		STAssertEqualObjects([components stringForKey:@"foo"], @"", @"");
		STAssertEqualObjects(components[@"foo"], @"", @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLEncoding componentsFromQueryString:@"foo&bar" error:&error];
		STAssertNotNil(components, @"error decoding query string: %@", error);
		STAssertTrue([components containsKey:@"foo"], @"");
		STAssertTrue([components containsKey:@"bar"], @"");
		STAssertNil([components stringForKey:@"foo"], @"");
		STAssertNil(components[@"foo"], @"");
		STAssertNil(components[@"bar"], @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLEncoding componentsFromQueryString:@"foo=baz&bar" error:&error];
		STAssertNotNil(components, @"error decoding query string: %@", error);
		STAssertTrue([components containsKey:@"foo"], @"");
		STAssertEqualObjects(components[@"foo"], @"baz", @"");
		STAssertEqualObjects([components stringForKey:@"foo"], @"baz", @"");
		STAssertEqualObjects([components stringsForKey:@"foo"], @[ @"baz" ], @"");
		STAssertTrue([components containsKey:@"bar"], @"");
		STAssertNil(components[@"bar"], @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLEncoding componentsFromQueryString:@"foo=baz&bar=" error:&error];
		STAssertNotNil(components, @"error decoding query string: %@", error);
		STAssertTrue([components containsKey:@"foo"], @"");
		STAssertEqualObjects(components[@"foo"], @"baz", @"");
		STAssertEqualObjects([components stringForKey:@"foo"], @"baz", @"");
		STAssertEqualObjects([components stringsForKey:@"foo"], @[ @"baz" ], @"");
		STAssertTrue([components containsKey:@"bar"], @"");
		STAssertEqualObjects(components[@"bar"], @"", @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLEncoding componentsFromQueryString:@"foo=baz&;&bar=" error:&error];
		STAssertNotNil(components, @"error decoding query string: %@", error);
		STAssertTrue([components containsKey:@"foo"], @"");
		STAssertEqualObjects(components[@"foo"], @"baz", @"");
		STAssertEqualObjects([components stringForKey:@"foo"], @"baz", @"");
		STAssertEqualObjects([components stringsForKey:@"foo"], @[ @"baz" ], @"");
		STAssertTrue([components containsKey:@"bar"], @"");
		STAssertEqualObjects(components[@"bar"], @"", @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLEncoding componentsFromQueryString:@"foo=baz&bar=&" error:&error];
		STAssertNotNil(components, @"error decoding query string: %@", error);
		STAssertTrue([components containsKey:@"foo"], @"");
		STAssertEqualObjects(components[@"foo"], @"baz", @"");
		STAssertEqualObjects([components stringForKey:@"foo"], @"baz", @"");
		STAssertEqualObjects([components stringsForKey:@"foo"], @[ @"baz" ], @"");
		STAssertTrue([components containsKey:@"bar"], @"");
		STAssertEqualObjects(components[@"bar"], @"", @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLEncoding componentsFromQueryString:@"foo=baz&bar=quux" error:&error];
		STAssertNotNil(components, @"error decoding query string: %@", error);
		STAssertTrue([components containsKey:@"foo"], @"");
		STAssertEqualObjects(components[@"foo"], @"baz", @"");
		STAssertTrue([components containsKey:@"bar"], @"");
		STAssertEqualObjects(components[@"bar"], @"quux", @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLEncoding componentsFromQueryString:@"foo&bar=quuux" error:&error];
		STAssertNotNil(components, @"error decoding query string: %@", error);
		STAssertTrue([components containsKey:@"foo"], @"");
		STAssertTrue([components containsKey:@"bar"], @"");
		STAssertEqualObjects(components[@"bar"], @"quuux", @"");
		STAssertNil([components stringForKey:@"foo"], @"");
		STAssertNil(components[@"foo"], @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLEncoding componentsFromQueryString:@"foo&bar=qu%20uux" error:&error];
		STAssertNotNil(components, @"error decoding query string: %@", error);
		STAssertTrue([components containsKey:@"foo"], @"");
		STAssertTrue([components containsKey:@"bar"], @"");
		STAssertEqualObjects(components[@"bar"], @"qu uux", @"");
		STAssertNil([components stringForKey:@"foo"], @"");
		STAssertNil(components[@"foo"], @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLEncoding componentsFromQueryString:@"f%26oo&bar=qu%20uux" error:&error];
		STAssertNotNil(components, @"error decoding query string: %@", error);
		STAssertTrue([components containsKey:@"f&oo"], @"");
		STAssertTrue([components containsKey:@"bar"], @"");
		STAssertEqualObjects(components[@"bar"], @"qu uux", @"");
		STAssertNil([components stringForKey:@"f&oo"], @"");
		STAssertNil(components[@"f&oo"], @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLEncoding componentsFromQueryString:@"f%26oo;bar=qu%20uux" error:&error];
		STAssertNotNil(components, @"error decoding query string: %@", error);
		STAssertTrue([components containsKey:@"f&oo"], @"");
		STAssertTrue([components containsKey:@"bar"], @"");
		STAssertEqualObjects(components[@"bar"], @"qu uux", @"");
		STAssertNil([components stringForKey:@"f&oo"], @"");
		STAssertNil(components[@"f&oo"], @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLEncoding componentsFromQueryString:@"foo;foo=qu%20uux&foo=" error:&error];
		STAssertNotNil(components, @"error decoding query string: %@", error);
		STAssertTrue([components containsKey:@"foo"], @"");
		NSArray *expected = @[ @"qu uux", @"" ];
		STAssertEqualObjects(components[@"foo"], expected, @"");
		STAssertEqualObjects([components stringsForKey:@"foo"], expected, @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLEncoding componentsFromQueryString:@"foo[]=;foo[]=qu%20uux&foo[]=" error:&error];
		STAssertNotNil(components, @"error decoding query string: %@", error);
		STAssertTrue([components containsKey:@"foo"], @"");
		NSArray *expected = @[ @"", @"qu uux", @"" ];
		STAssertEqualObjects(components[@"foo"], expected, @"");
		STAssertEqualObjects([components stringsForKey:@"foo"], expected, @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLEncoding componentsFromQueryString:@"fo/o[]=;foo[]=qu%20uux&foo[]=" error:&error];
		STAssertNotNil(components, @"error decoding query string: %@", error);
		STAssertTrue([components containsKey:@"foo"], @"");
		STAssertTrue([components containsKey:@"fo/o"], @"");
		STAssertEqualObjects(components[@"fo/o"], @"", @"");
		{
			NSArray *expected = @[ @"qu uux", @"" ];
			STAssertEqualObjects(components[@"foo"], expected, @"");
			STAssertEqualObjects([components stringsForKey:@"foo"], expected, @"");
		}
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLEncoding componentsFromQueryString:@"foo[]=;foo[]=qu%20u/ux&foo[]=" error:&error];
		STAssertNotNil(components, @"error decoding query string: %@", error);
		STAssertTrue([components containsKey:@"foo"], @"");
		NSArray *expected = @[ @"", @"qu u/ux", @"" ];
		STAssertEqualObjects(components[@"foo"], expected, @"");
		STAssertEqualObjects([components stringsForKey:@"foo"], expected, @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLEncoding componentsFromQueryString:@"fo?o[]=;foo[]=qu%20uux&foo[]=" error:&error];
		STAssertNotNil(components, @"error decoding query string: %@", error);
		STAssertTrue([components containsKey:@"foo"], @"");
		STAssertTrue([components containsKey:@"fo?o"], @"");
		STAssertEqualObjects(components[@"fo?o"], @"", @"");
		{
			NSArray *expected = @[ @"qu uux", @"" ];
			STAssertEqualObjects(components[@"foo"], expected, @"");
			STAssertEqualObjects([components stringsForKey:@"foo"], expected, @"");
		}
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLEncoding componentsFromQueryString:@"foo[]=;foo[]=qu%20u?ux&foo[]=" error:&error];
		STAssertNotNil(components, @"error decoding query string: %@", error);
		STAssertTrue([components containsKey:@"foo"], @"");
		NSArray *expected = @[ @"", @"qu u?ux", @"" ];
		STAssertEqualObjects(components[@"foo"], expected, @"");
		STAssertEqualObjects([components stringsForKey:@"foo"], expected, @"");
	}
}

@end
