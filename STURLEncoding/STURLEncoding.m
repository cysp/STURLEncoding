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
- (NSArray *)allKeys;
@end

@implementation STURLQueryStringComponents {
@package
	NSMutableDictionary *_components;
}

+ (instancetype)components {
	return [[self alloc] init];
}

- (id)init {
	if ((self = [super init])) {
		_components = [NSMutableDictionary dictionary];
	}
	return self;
}

- (id)copyWithZone:(NSZone *)zone {
	STURLQueryStringComponents *other = [[STURLQueryStringComponents allocWithZone:zone] init];
	[_components enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		NSMutableArray *otherStrings = [[NSMutableArray allocWithZone:zone] initWithArray:obj copyItems:YES];
		[other->_components setObject:otherStrings forKey:key];
	}];
	return other;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
	STMutableURLQueryStringComponents *other = [[STMutableURLQueryStringComponents allocWithZone:zone] init];
	[_components enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		NSMutableArray *otherStrings = [[NSMutableArray allocWithZone:zone] initWithArray:obj copyItems:YES];
		[other->_components setObject:otherStrings forKey:key];
	}];
	return other;
}


- (BOOL)containsKey:(NSString *)key {
	return [_components objectForKey:key] != nil;
}

- (NSArray *)allKeys {
	return [_components allKeys];
}

- (NSArray *)stringsForKey:(NSString *)key {
	return [_components objectForKey:key];
}

- (NSString *)stringForKey:(NSString *)key {
	NSArray *strings = [_components objectForKey:key];
	return [strings count] ? [strings objectAtIndex:0] : nil;
}

- (id)objectForKeyedSubscript:(NSString *)key {
	NSArray *strings = [_components objectForKey:key];
	if ([strings count] == 1) {
		return [strings lastObject];
	}
	return [strings count] ? strings : nil;
}

@end


@implementation STMutableURLQueryStringComponents

- (void)addString:(NSString *)string forKey:(NSString *)key {
	NSMutableArray *stringsForKey = [_components objectForKey:key];
	if (!stringsForKey) {
		stringsForKey = [NSMutableArray array];
		[_components setObject:stringsForKey forKey:key];
	}

	if (string) {
		[stringsForKey addObject:string];
	}
}

- (void)setString:(NSString *)string forKey:(NSString *)key {
	NSArray *strings = string ? @[ string ] : nil;
	[self setStrings:strings forKey:key];
}

- (void)setStrings:(NSArray *)strings forKey:(NSString *)key {
	if (strings) {
		strings = [[NSMutableArray alloc] initWithArray:strings copyItems:YES];
		[_components setObject:strings forKey:key];
	} else {
		[_components removeObjectForKey:key];
	}
}

- (void)removeStringsForKey:(NSString *)key {
	[_components removeObjectForKey:key];
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
	string = [string stringByReplacingOccurrencesOfString:@"+" withString:@" "];
	NSString *decoded = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)string, CFSTR(""), kCFStringEncodingUTF8);
	return decoded;
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
		if ([decodedKey hasSuffix:@"[]"]) {
			decodedKey = [decodedKey substringToIndex:[decodedKey length] - 2];
		}

		[components addString:decodedValue forKey:decodedKey];
	}

	return [components copy];
}

@end
