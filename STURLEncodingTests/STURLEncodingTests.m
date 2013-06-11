//
//  STURLEncodingTests.m
//  STURLEncoding
//
//  Copyright (c) 2012-2013 Scott Talbot. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import "STURLEncoding.h"


@interface STURLEncodingTests : SenTestCase
@end


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

@end
