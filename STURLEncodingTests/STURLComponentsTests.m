//
//  STURLComponentsTests.m
//  STURLEncoding
//
//  Copyright (c) 2013 Scott Talbot. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import "STURLComponents.h"


@interface STURLComponentsTests : SenTestCase
@end


@implementation STURLComponentsTests

- (void)testBuilding {
	{
		NSString * const input = @"http://www.ics.uci.edu/pub/ietf/uri/#Related";
		STMutableURLComponents * const st = [STMutableURLComponents componentsWithString:input];
		STAssertEqualObjects(st.scheme, @"http", @"");
		st.scheme = @"https";
		STAssertEqualObjects(st.scheme, @"https", @"");
		NSString * const output = [st URLString];
		STAssertEqualObjects(output, @"https://www.ics.uci.edu/pub/ietf/uri/#Related", @"");
	}
}

- (void)testParsing {
	{
		NSString * const input = @"http://www.ics.uci.edu/pub/ietf/uri/#Related";
		STURLComponents * const st = [STURLComponents componentsWithString:input];
		STAssertNotNil(st, @"");

		STAssertEqualObjects(st.scheme, @"http", @"");
		STAssertNil(st.user, @"");
		STAssertNil(st.password, @"");
		STAssertEqualObjects(st.host, @"www.ics.uci.edu", @"");
		STAssertNil(st.port, @"");
		STAssertEqualObjects(st.path, @"/pub/ietf/uri/", @"");
		STAssertNil(st.query, @"");
		STAssertEqualObjects(st.fragment, @"Related", @"");

		NSString * const output = [st URLString];
		STAssertEqualObjects(output, input, @"");
	}

	{
		NSString * const input = @"scheme://user:password@host/path?query#fragment";
		STURLComponents * const st = [STURLComponents componentsWithString:input];
		STAssertNotNil(st, @"");

		STAssertEqualObjects(st.scheme, @"scheme", @"");
		STAssertEqualObjects(st.user, @"user", @"");
		STAssertEqualObjects(st.password, @"password", @"");
		STAssertEqualObjects(st.host, @"host", @"");
		STAssertNil(st.port, @"");
		STAssertEqualObjects(st.path, @"/path", @"");
		STAssertEqualObjects(st.query, @"query", @"");
		STAssertEqualObjects(st.fragment, @"fragment", @"");

		NSString * const output = [st URLString];
		STAssertEqualObjects(output, input, @"");
	}

	{
		NSString * const input = @"scheme://user:password@host:1/path?query#fragment";
		STURLComponents * const st = [STURLComponents componentsWithString:input];
		STAssertNotNil(st, @"");

		STAssertEqualObjects(st.scheme, @"scheme", @"");
		STAssertEqualObjects(st.user, @"user", @"");
		STAssertEqualObjects(st.password, @"password", @"");
		STAssertEqualObjects(st.host, @"host", @"");
		STAssertEqualObjects(st.port, @(1), @"");
		STAssertEqualObjects(st.path, @"/path", @"");
		STAssertEqualObjects(st.query, @"query", @"");
		STAssertEqualObjects(st.fragment, @"fragment", @"");

		NSString * const output = [st URLString];
		STAssertEqualObjects(output, input, @"");
	}

	{
		NSString * const input = @"scheme://user@host/path?query#fragment";
		STURLComponents * const st = [STURLComponents componentsWithString:input];
		STAssertNotNil(st, @"");

		STAssertEqualObjects(st.scheme, @"scheme", @"");
		STAssertEqualObjects(st.user, @"user", @"");
		STAssertNil(st.password, @"");
		STAssertEqualObjects(st.host, @"host", @"");
		STAssertNil(st.port, @"");
		STAssertEqualObjects(st.path, @"/path", @"");
		STAssertEqualObjects(st.query, @"query", @"");
		STAssertEqualObjects(st.fragment, @"fragment", @"");

		NSString * const output = [st URLString];
		STAssertEqualObjects(output, input, @"");
	}

	{
		NSString * const input = @"scheme://user@host:1/path?query#fragment";
		STURLComponents * const st = [STURLComponents componentsWithString:input];
		STAssertNotNil(st, @"");

		STAssertEqualObjects(st.scheme, @"scheme", @"");
		STAssertEqualObjects(st.user, @"user", @"");
		STAssertNil(st.password, @"");
		STAssertEqualObjects(st.host, @"host", @"");
		STAssertEqualObjects(st.port, @(1), @"");
		STAssertEqualObjects(st.path, @"/path", @"");
		STAssertEqualObjects(st.query, @"query", @"");
		STAssertEqualObjects(st.fragment, @"fragment", @"");

		NSString * const output = [st URLString];
		STAssertEqualObjects(output, input, @"");
	}

	{
		NSString * const input = @"ftp://ftp.is.co.za/rfc/rfc1808.txt";
		STURLComponents * const st = [STURLComponents componentsWithString:input];
		STAssertNotNil(st, @"");

		STAssertEqualObjects(st.scheme, @"ftp", @"");
		STAssertNil(st.user, @"");
		STAssertNil(st.password, @"");
		STAssertEqualObjects(st.host, @"ftp.is.co.za", @"");
		STAssertNil(st.port, @"");
		STAssertEqualObjects(st.path, @"/rfc/rfc1808.txt", @"");
		STAssertNil(st.query, @"");
		STAssertNil(st.fragment, @"");

		NSString * const output = [st URLString];
		STAssertEqualObjects(output, input, @"");
	}

	{
		NSString * const input = @"http://www.ietf.org/rfc/rfc2396.txt";
		STURLComponents * const st = [STURLComponents componentsWithString:input];
		STAssertNotNil(st, @"");

		STAssertEqualObjects(st.scheme, @"http", @"");
		STAssertNil(st.user, @"");
		STAssertNil(st.password, @"");
		STAssertEqualObjects(st.host, @"www.ietf.org", @"");
		STAssertNil(st.port, @"");
		STAssertEqualObjects(st.path, @"/rfc/rfc2396.txt", @"");
		STAssertNil(st.query, @"");
		STAssertNil(st.fragment, @"");

		NSString * const output = [st URLString];
		STAssertEqualObjects(output, input, @"");
	}

	{
		NSString * const input = @"ldap://[2001:db8::7]/c=GB?objectClass?one";
		STURLComponents * const st = [STURLComponents componentsWithString:input];
		STAssertNotNil(st, @"");

		STAssertEqualObjects(st.scheme, @"ldap", @"");
		STAssertNil(st.user, @"");
		STAssertNil(st.password, @"");
		STAssertEqualObjects(st.host, @"[2001:db8::7]", @"");
		STAssertNil(st.port, @"");
		STAssertEqualObjects(st.path, @"/c=GB", @"");
		STAssertEqualObjects(st.query, @"objectClass?one", @"");
		STAssertNil(st.fragment, @"");

		NSString * const output = [st URLString];
		STAssertEqualObjects(output, input, @"");
	}

	{
		NSString * const input = @"mailto:John.Doe@example.com";
		STURLComponents * const st = [STURLComponents componentsWithString:input];
		STAssertNotNil(st, @"");

		STAssertEqualObjects(st.scheme, @"mailto", @"");
		STAssertNil(st.user, @"");
		STAssertNil(st.password, @"");
		STAssertNil(st.host, @"");
		STAssertNil(st.port, @"");
		STAssertEqualObjects(st.path, @"John.Doe@example.com", @"");
		STAssertNil(st.query, @"");
		STAssertNil(st.fragment, @"");

		NSString * const output = [st URLString];
		STAssertEqualObjects(output, input, @"");
	}

	{
		NSString * const input = @"news:comp.infosystems.www.servers.unix";
		STURLComponents * const st = [STURLComponents componentsWithString:input];
		STAssertNotNil(st, @"");

		STAssertEqualObjects(st.scheme, @"news", @"");
		STAssertNil(st.user, @"");
		STAssertNil(st.password, @"");
		STAssertNil(st.host, @"");
		STAssertNil(st.port, @"");
		STAssertEqualObjects(st.path, @"comp.infosystems.www.servers.unix", @"");
		STAssertNil(st.query, @"");
		STAssertNil(st.fragment, @"");

		NSString * const output = [st URLString];
		STAssertEqualObjects(output, input, @"");
	}

	{
		NSString * const input = @"tel:+1-816-555-1212";
		STURLComponents * const st = [STURLComponents componentsWithString:input];
		STAssertNotNil(st, @"");

		STAssertEqualObjects(st.scheme, @"tel", @"");
		STAssertNil(st.user, @"");
		STAssertNil(st.password, @"");
		STAssertNil(st.host, @"");
		STAssertNil(st.port, @"");
		STAssertEqualObjects(st.path, @"+1-816-555-1212", @"");
		STAssertNil(st.query, @"");
		STAssertNil(st.fragment, @"");

		NSString * const output = [st URLString];
		STAssertEqualObjects(output, input, @"");
	}

	{
		NSString * const input = @"telnet://192.0.2.16:80/";
		STURLComponents * const st = [STURLComponents componentsWithString:input];
		STAssertNotNil(st, @"");

		STAssertEqualObjects(st.scheme, @"telnet", @"");
		STAssertNil(st.user, @"");
		STAssertNil(st.password, @"");
		STAssertEqualObjects(st.host, @"192.0.2.16", @"");
		STAssertEqualObjects(st.port, @(80), @"");
		STAssertEqualObjects(st.path, @"/", @"");
		STAssertNil(st.query, @"");
		STAssertNil(st.fragment, @"");

		NSString * const output = [st URLString];
		STAssertEqualObjects(output, input, @"");
	}

	{
		NSString * const input = @"urn:oasis:names:specification:docbook:dtd:xml:4.1.2";
		STURLComponents * const st = [STURLComponents componentsWithString:input];
		STAssertNotNil(st, @"");

		STAssertEqualObjects(st.scheme, @"urn", @"");
		STAssertNil(st.user, @"");
		STAssertNil(st.password, @"");
		STAssertNil(st.host, @"");
		STAssertNil(st.port, @"");
		STAssertEqualObjects(st.path, @"oasis:names:specification:docbook:dtd:xml:4.1.2", @"");
		STAssertNil(st.query, @"");
		STAssertNil(st.fragment, @"");

		NSString * const output = [st URLString];
		STAssertEqualObjects(output, input, @"");
	}

	{
		NSString * const input = @"ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm";
		STURLComponents * const st = [STURLComponents componentsWithString:input];
		STAssertNotNil(st, @"");

		STAssertEqualObjects(st.scheme, @"ftp", @"");
		STAssertEqualObjects(st.user, @"cnn.example.com&story=breaking_news", @"");
		STAssertNil(st.password, @"");
		STAssertEqualObjects(st.host, @"10.0.0.1", @"");
		STAssertNil(st.port, @"");
		STAssertEqualObjects(st.path, @"/top_story.htm", @"");
		STAssertNil(st.query, @"");
		STAssertNil(st.fragment, @"");

		NSString * const output = [st URLString];
		STAssertEqualObjects(output, input, @"");
	}

	{
		NSString * const input = @"https://user:password@[2404:6800:4006:801::1009]:443";
		STURLComponents * const st = [STURLComponents componentsWithString:input];
		STAssertNotNil(st, @"");

		STAssertEqualObjects(st.scheme, @"https", @"");
		STAssertEqualObjects(st.user, @"user", @"");
		STAssertEqualObjects(st.password, @"password", @"");
		STAssertEqualObjects(st.host, @"[2404:6800:4006:801::1009]", @"");
		STAssertEqualObjects(st.port, @(443), @"");
		STAssertNil(st.path, @"");
		STAssertNil(st.query, @"");
		STAssertNil(st.fragment, @"");

		NSString * const output = [st URLString];
		STAssertEqualObjects(output, input, @"");
	}

	{
		NSString * const input = @"https://user:password@[2404:6800:4006:801::1009]:443?query";
		STURLComponents * const st = [STURLComponents componentsWithString:input];
		STAssertNotNil(st, @"");

		STAssertEqualObjects(st.scheme, @"https", @"");
		STAssertEqualObjects(st.user, @"user", @"");
		STAssertEqualObjects(st.password, @"password", @"");
		STAssertEqualObjects(st.host, @"[2404:6800:4006:801::1009]", @"");
		STAssertEqualObjects(st.port, @(443), @"");
		STAssertNil(st.path, @"");
		STAssertEqualObjects(st.query, @"query", @"");
		STAssertNil(st.fragment, @"");

		NSString * const output = [st URLString];
		STAssertEqualObjects(output, input, @"");
	}
}

- (void)testEquality {
	{
		STMutableURLComponents *a = [STMutableURLComponents componentsWithString:@""];
		STMutableURLComponents *b = [STMutableURLComponents componentsWithString:@""];
		STAssertTrue([a isEqual:b], @"");
		a.scheme = @"a";
		STAssertFalse([a isEqual:b], @"");
		b.scheme = @"a";
		STAssertTrue([a isEqual:b], @"");
		b.scheme = @"b";
		STAssertFalse([a isEqual:b], @"");
		a.scheme = nil;
		STAssertFalse([a isEqual:b], @"");
	}
}

@end
