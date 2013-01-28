//
//  STURLQueryStringEncoding.m
//  STURLEncoding
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2012-2013 Scott Talbot. All rights reserved.
//

#import "STURLQueryStringEncoding.h"
#import "STURLEncoding.h"


@implementation STURLQueryStringEncoding {
}

#pragma mark - Query String Building

+ (NSString *)queryStringFromComponents:(STURLQueryStringComponents *)components {
	NSMutableString *queryString = [NSMutableString string];
	NSArray *keys = [[components allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *a, NSString *b) {
		return [a compare:b options:NSCaseInsensitiveSearch|NSNumericSearch|NSDiacriticInsensitiveSearch|NSWidthInsensitiveSearch|NSForcedOrderingSearch];
	}];
	for (NSString *key in keys) {
		NSArray *strings = [components stringsForKey:key];
		if ([strings count] == 0) {
			continue;
		}
		if ([strings count] == 1) {
			if ([queryString length]) {
				[queryString appendString:@"&"];
			}
			[queryString appendFormat:@"%@=%@", [STURLEncoding stringByURLEncodingString:key], [STURLEncoding stringByURLEncodingString:[strings lastObject]]];
		} else {
			for (NSString *string in strings) {
				if ([queryString length]) {
					[queryString appendString:@"&"];
				}
				[queryString appendFormat:@"%@[]=%@", [STURLEncoding stringByURLEncodingString:key], [STURLEncoding stringByURLEncodingString:string]];
			}
		}
	}
	return queryString;
}


#pragma mark - Query String Decoding

+ (STURLQueryStringComponents *)componentsFromQueryString:(NSString *)string {
	return [self componentsFromQueryString:string error:NULL];
}

+ (STURLQueryStringComponents *)componentsFromQueryString:(NSString *)string error:(NSError *__autoreleasing *)error {
	NSCharacterSet *separatorsCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
	NSCharacterSet *equalsCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"="];
	NSCharacterSet *separatorsOrEqualsCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;="];

	NSScanner *scanner = [NSScanner scannerWithString:string];

	STMutableURLQueryStringComponents *components = [[STMutableURLQueryStringComponents alloc] init];

	while (![scanner isAtEnd]) {
		NSString *key = nil, *value = @"";
		if (![scanner scanUpToCharactersFromSet:separatorsOrEqualsCharacterSet intoString:&key]) {
			if (error) {
				*error = [NSError errorWithDomain:kSTURLEncodingErrorDomain code:STURLEncodingErrorCodeUnknown userInfo:nil];
			}
			return nil;
		}
		if ([scanner scanCharactersFromSet:equalsCharacterSet intoString:NULL]) {
			[scanner scanUpToCharactersFromSet:separatorsCharacterSet intoString:&value];
		}
		if (![scanner isAtEnd]) {
			[scanner scanCharactersFromSet:separatorsCharacterSet intoString:NULL];
		}

		NSString *decodedKey = [STURLEncoding stringByURLDecodingString:key];
		if ([key length] && ![decodedKey length]) {
			if (error) {
				*error = [NSError errorWithDomain:kSTURLEncodingErrorDomain code:STURLEncodingErrorCodeUnknown userInfo:nil];
			}
			return nil;
		}

		NSString *decodedValue = [STURLEncoding stringByURLDecodingString:value];
		if ([value length] && ![decodedValue length]) {
			if (error) {
				*error = [NSError errorWithDomain:kSTURLEncodingErrorDomain code:STURLEncodingErrorCodeUnknown userInfo:nil];
			}
			return nil;
		}
		if ([decodedKey hasSuffix:@"[]"]) {
			decodedKey = [decodedKey substringToIndex:[decodedKey length] - 2];
		}

		[components addString:decodedValue forKey:decodedKey];
	}

	return [components copy];
}

@end
