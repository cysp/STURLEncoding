//
//  STURLEncodingTests.m
//  STURLEncoding
//
//  Copyright (c) 2012-2014 Scott Talbot. All rights reserved.
//

@import XCTest;

#import "STURLEncoding.h"


@interface STURLEncodingTests : XCTestCase
@end


@implementation STURLEncodingTests {
	NSArray *_urlEncodingTable;
}

- (void)setUp {
	NSString * const eightzero = [[NSString alloc] initWithCharacters:(unichar[]){ 0x80 } length:1];
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
		@[ eightzero, @"%C2%80" ],
		@[ @"\u3001", @"%E3%80%81" ],
	];
}

- (void)tearDown {
	_urlEncodingTable = nil;
}

- (void)testURLEncoding {
	XCTAssertNotNil(_urlEncodingTable, @"");

	for (NSArray *testcase in _urlEncodingTable) {
		NSString *input = testcase[0];
		NSString *expected = testcase[1];
		NSString *output = [STURLEncoding stringByURLEncodingString:input];
		XCTAssertNotNil(output, @"error encoding");
		XCTAssertEqualObjects(output, expected, @"encoding output doesn't match expected");
	}
}

- (void)testURLDecoding {
	XCTAssertNotNil(_urlEncodingTable, @"");

	for (NSArray *testcase in _urlEncodingTable) {
		NSString *input = testcase[1];
		NSString *expected = testcase[0];
		NSString *output = [STURLEncoding stringByURLDecodingString:input];
		XCTAssertNotNil(output, @"error decoding");
		XCTAssertEqualObjects(output, expected, @"decoding output doesn't match expected");
	}
}

@end
