//
//  STURLEncoding.m
//  STURLEncoding
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2012 Scott Talbot. All rights reserved.
//

#import "STURLEncoding.h"


NSString * const kSTURLEncodingErrorDomain = @"STURLEncoding";


@interface STURLQueryStringComponents ()
- (void)addValue:(NSString *)value forKey:(NSString *)key;
@end

@implementation STURLQueryStringComponents {
	NSMutableDictionary *_components;
}

- (id)init {
	if ((self = [super init])) {
		_components = [NSMutableDictionary dictionary];
	}
	return self;
}


- (void)addValue:(NSString *)value forKey:(NSString *)key {
	NSMutableArray *valuesForKey = [_components objectForKey:key];
	if (!valuesForKey) {
		valuesForKey = [NSMutableArray array];
		[_components setObject:valuesForKey forKey:key];
	}

	if (value) {
		[valuesForKey addObject:value];
	}
}

- (BOOL)containsKey:(NSString *)key {
	return [_components objectForKey:key] != nil;
}

- (NSArray *)valuesForKey:(NSString *)key {
	return [_components objectForKey:key];
}

- (NSString *)valueForKey:(NSString *)key {
	NSArray *values = [_components objectForKey:key];
	return [values count] ? [values objectAtIndex:0] : nil;
}

- (id)objectForKeyedSubscript:(NSString *)key {
	NSArray *values = [_components objectForKey:key];
	if ([values count] == 1) {
		return [values lastObject];
	}
	return [values count] ? values : nil;
}

@end


@implementation STURLEncoding {
}

#pragma mark - URLEncoding

// The character sets here are from RFC3986

+ (NSString *)stringByURLEncodingString:(NSString *)string {
	NSString *encoded = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
	    (__bridge CFStringRef)string,
	    CFSTR("-.0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz~"),
	    CFSTR("!#$&'()*+,/:;=?@[]"),
	    kCFStringEncodingUTF8);
	return encoded;
}


#pragma mark - URLDecoding

+ (NSString *)stringByURLDecodingString:(NSString *)string {
	NSString *decoded = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)string, CFSTR(""), kCFStringEncodingUTF8);
	return decoded;
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

	STURLQueryStringComponents *components = [[STURLQueryStringComponents alloc] init];

	while (![scanner isAtEnd]) {
		NSString *key = nil, *value = nil;
		if (![scanner scanUpToCharactersFromSet:separatorsOrEqualsCharacterSet intoString:&key]) {
			if (error) {
				*error = [NSError errorWithDomain:kSTURLEncodingErrorDomain code:STURLEncodingErrorCodeUnknown userInfo:nil];
			}
			return nil;
		}
		if ([scanner scanCharactersFromSet:equalsCharacterSet intoString:NULL]) {
			if (![scanner scanUpToCharactersFromSet:separatorsCharacterSet intoString:&value]) {
				value = @"";
			}
		}
		if (![scanner isAtEnd]) {
			if (![scanner scanCharactersFromSet:separatorsCharacterSet intoString:NULL]) {
				if (error) {
					*error = [NSError errorWithDomain:kSTURLEncodingErrorDomain code:STURLEncodingErrorCodeUnknown userInfo:nil];
				}
				return nil;
			}
		}

		NSString *decodedKey = [self stringByURLDecodingString:key];
		if ([key length] && ![decodedKey length]) {
			if (error) {
				*error = [NSError errorWithDomain:kSTURLEncodingErrorDomain code:STURLEncodingErrorCodeUnknown userInfo:nil];
			}
			return nil;
		}

		NSString *decodedValue = [self stringByURLDecodingString:value];
		if ([value length] && ![decodedValue length]) {
			if (error) {
				*error = [NSError errorWithDomain:kSTURLEncodingErrorDomain code:STURLEncodingErrorCodeUnknown userInfo:nil];
			}
			return nil;
		}

		[components addValue:decodedValue forKey:decodedKey];
	}

	return components;
}

@end
