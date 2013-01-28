//
//  STURLQueryStringEncodingTests.m
//  STURLEncoding
//
//  Copyright (c) 2012-2013 Scott Talbot. All rights reserved.
//

#import "STURLQueryStringEncodingTests.h"

#import "STURLQueryStringEncoding.h"


@implementation STURLQueryStringEncodingTests

- (void)testQueryStringComponents {
	{
		STMutableURLQueryStringComponents *components = [STMutableURLQueryStringComponents components];

		[components setString:nil forKey:@"a"];
		STAssertFalse([components containsKey:@"a"], @"", nil);
		{
			NSString *queryString = [STURLQueryStringEncoding queryStringFromComponents:components];
			STAssertEqualObjects(queryString, @"", @"");
		}

		[components setString:@"" forKey:@"a"];
		STAssertTrue([components containsKey:@"a"], @"", nil);
		{
			NSString *queryString = [STURLQueryStringEncoding queryStringFromComponents:components];
			STAssertEqualObjects(queryString, @"a=", @"");
		}

		[components removeStringsForKey:@"a"];
		STAssertFalse([components containsKey:@"a"], @"", nil);
		{
			NSString *queryString = [STURLQueryStringEncoding queryStringFromComponents:components];
			STAssertEqualObjects(queryString, @"", @"");
		}
	}
	{
		STMutableURLQueryStringComponents *components = [STMutableURLQueryStringComponents components];
		[components addString:nil forKey:@"a"];
		STAssertFalse([components containsKey:@"a"], @"", nil);
	}
}


- (void)testQueryStringBuilding {
	{
		STMutableURLQueryStringComponents *components = [STMutableURLQueryStringComponents components];
		[components setString:@"bar" forKey:@"foo"];
		STAssertTrue([components containsKey:@"foo"], @"");
		STAssertEqualObjects([components stringForKey:@"foo"], @"bar", @"");
		NSString *queryString = [STURLQueryStringEncoding queryStringFromComponents:components];
		STAssertEqualObjects(queryString, @"foo=bar", @"");
	}
	{
		STMutableURLQueryStringComponents *components = [STMutableURLQueryStringComponents components];
		[components setString:@"bar" forKey:@"foo"];
		[components addString:@"baz" forKey:@"foo"];
		STAssertTrue([components containsKey:@"foo"], @"");
		STAssertEqualObjects([components stringForKey:@"foo"], @"bar", @"");
		NSArray *foo = @[ @"bar", @"baz" ];
		STAssertEqualObjects([components stringsForKey:@"foo"], foo, @"");
		NSString *queryString = [STURLQueryStringEncoding queryStringFromComponents:components];
		STAssertEqualObjects(queryString, @"foo[]=bar&foo[]=baz", @"");
	}
	{
		STMutableURLQueryStringComponents *components = [STMutableURLQueryStringComponents components];
		[components setString:@"bar" forKey:@"foo"];
		[components setString:@"AAA" forKey:@"aaa"];
		STAssertTrue([components containsKey:@"foo"], @"");
		STAssertEqualObjects([components stringForKey:@"foo"], @"bar", @"");
		NSString *queryString = [STURLQueryStringEncoding queryStringFromComponents:components];
		STAssertEqualObjects(queryString, @"aaa=AAA&foo=bar", @"");
	}
	{
		STMutableURLQueryStringComponents *components = [STMutableURLQueryStringComponents components];
		[components setString:@"b?r" forKey:@"foo"];
		[components setString:@"A&A" forKey:@"aaa"];
		STAssertTrue([components containsKey:@"foo"], @"");
		STAssertEqualObjects([components stringForKey:@"foo"], @"b?r", @"");
		NSString *queryString = [STURLQueryStringEncoding queryStringFromComponents:components];
		STAssertEqualObjects(queryString, @"aaa=A%26A&foo=b%3Fr", @"");
	}
}

- (void)testQueryString {
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"foo" error:&error];
		STAssertNotNil(components, @"error decoding query string: %@", error);
		STAssertTrue([components containsKey:@"foo"], @"");
		STAssertFalse([components containsKey:@"bar"], @"");
		STAssertEqualObjects([components stringForKey:@"foo"], @"", @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"foo=" error:&error];
		STAssertNotNil(components, @"error decoding query string: %@", error);
		STAssertTrue([components containsKey:@"foo"], @"");
		STAssertFalse([components containsKey:@"bar"], @"");
		STAssertEqualObjects([components stringForKey:@"foo"], @"", @"");
		STAssertEqualObjects(components[@"foo"], @"", @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"foo&bar" error:&error];
		STAssertNotNil(components, @"error decoding query string: %@", error);
		STAssertTrue([components containsKey:@"foo"], @"");
		STAssertTrue([components containsKey:@"bar"], @"");
		STAssertEqualObjects([components stringForKey:@"foo"], @"", @"");
		STAssertEqualObjects([components stringForKey:@"bar"], @"", @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"foo=baz&bar" error:&error];
		STAssertNotNil(components, @"error decoding query string: %@", error);
		STAssertTrue([components containsKey:@"foo"], @"");
		STAssertEqualObjects(components[@"foo"], @"baz", @"");
		STAssertEqualObjects([components stringForKey:@"foo"], @"baz", @"");
		STAssertEqualObjects([components stringsForKey:@"foo"], @[ @"baz" ], @"");
		STAssertTrue([components containsKey:@"bar"], @"");
		STAssertEqualObjects([components stringForKey:@"bar"], @"", @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"foo=baz&bar=" error:&error];
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
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"foo=baz&;&bar=" error:&error];
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
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"foo=baz&bar=&" error:&error];
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
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"foo=baz&bar=quux" error:&error];
		STAssertNotNil(components, @"error decoding query string: %@", error);
		STAssertTrue([components containsKey:@"foo"], @"");
		STAssertEqualObjects(components[@"foo"], @"baz", @"");
		STAssertTrue([components containsKey:@"bar"], @"");
		STAssertEqualObjects(components[@"bar"], @"quux", @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"foo&bar=quuux" error:&error];
		STAssertNotNil(components, @"error decoding query string: %@", error);
		STAssertTrue([components containsKey:@"foo"], @"");
		STAssertTrue([components containsKey:@"bar"], @"");
		STAssertEqualObjects(components[@"bar"], @"quuux", @"");
		STAssertEqualObjects([components stringForKey:@"foo"], @"", @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"foo&bar=qu%20uux" error:&error];
		STAssertNotNil(components, @"error decoding query string: %@", error);
		STAssertTrue([components containsKey:@"foo"], @"");
		STAssertTrue([components containsKey:@"bar"], @"");
		STAssertEqualObjects(components[@"bar"], @"qu uux", @"");
		STAssertEqualObjects([components stringForKey:@"foo"], @"", @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"f%26oo&bar=qu%20uux" error:&error];
		STAssertNotNil(components, @"error decoding query string: %@", error);
		STAssertTrue([components containsKey:@"f&oo"], @"");
		STAssertTrue([components containsKey:@"bar"], @"");
		STAssertEqualObjects(components[@"bar"], @"qu uux", @"");
		STAssertEqualObjects([components stringForKey:@"f&oo"], @"", @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"f%26oo;bar=qu%20uux" error:&error];
		STAssertNotNil(components, @"error decoding query string: %@", error);
		STAssertTrue([components containsKey:@"f&oo"], @"");
		STAssertTrue([components containsKey:@"bar"], @"");
		STAssertEqualObjects(components[@"bar"], @"qu uux", @"");
		STAssertEqualObjects([components stringForKey:@"f&oo"], @"", @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"f+oo;bar=qu%20uux" error:&error];
		STAssertNotNil(components, @"error decoding query string: %@", error);
		STAssertTrue([components containsKey:@"f oo"], @"");
		STAssertTrue([components containsKey:@"bar"], @"");
		STAssertEqualObjects([components stringForKey:@"f oo"], @"", @"");
		STAssertEqualObjects(components[@"bar"], @"qu uux", @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"f+oo;bar=qu%20u+ux" error:&error];
		STAssertNotNil(components, @"error decoding query string: %@", error);
		STAssertTrue([components containsKey:@"f oo"], @"");
		STAssertTrue([components containsKey:@"bar"], @"");
		STAssertEqualObjects([components stringForKey:@"f oo"], @"", @"");
		STAssertEqualObjects(components[@"bar"], @"qu u ux", @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"foo=qu%20uux&foo=" error:&error];
		STAssertNotNil(components, @"error decoding query string: %@", error);
		STAssertTrue([components containsKey:@"foo"], @"");
		NSArray *expected = @[ @"qu uux", @"" ];
		STAssertEqualObjects(components[@"foo"], expected, @"");
		STAssertEqualObjects([components stringsForKey:@"foo"], expected, @"");
		STAssertEqualObjects([components stringForKey:@"foo"], @"qu uux", @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"foo[]=;foo[]=qu%20uux&foo[]=" error:&error];
		STAssertNotNil(components, @"error decoding query string: %@", error);
		STAssertTrue([components containsKey:@"foo"], @"");
		NSArray *expected = @[ @"", @"qu uux", @"" ];
		STAssertEqualObjects(components[@"foo"], expected, @"");
		STAssertEqualObjects([components stringsForKey:@"foo"], expected, @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"fo/o[]=;foo[]=qu%20uux&foo[]=" error:&error];
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
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"foo[]=;foo[]=qu%20u/ux&foo[]=" error:&error];
		STAssertNotNil(components, @"error decoding query string: %@", error);
		STAssertTrue([components containsKey:@"foo"], @"");
		NSArray *expected = @[ @"", @"qu u/ux", @"" ];
		STAssertEqualObjects(components[@"foo"], expected, @"");
		STAssertEqualObjects([components stringsForKey:@"foo"], expected, @"");
	}
	{
		NSError *error = nil;
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"fo?o[]=;foo[]=qu%20uux&foo[]=" error:&error];
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
		STURLQueryStringComponents *components = [STURLQueryStringEncoding componentsFromQueryString:@"foo[]=;foo[]=qu%20u?ux&foo[]=" error:&error];
		STAssertNotNil(components, @"error decoding query string: %@", error);
		STAssertTrue([components containsKey:@"foo"], @"");
		NSArray *expected = @[ @"", @"qu u?ux", @"" ];
		STAssertEqualObjects(components[@"foo"], expected, @"");
		STAssertEqualObjects([components stringsForKey:@"foo"], expected, @"");
	}
}

@end
