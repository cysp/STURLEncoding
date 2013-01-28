//
//  STURLQueryStringComponents.m
//  STURLEncoding
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Created by Scott Talbot on 28/01/13.
//  Copyright (c) 2012-2013 Scott Talbot. All rights reserved.
//

#import "STURLQueryStringComponents.h"


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
	if (string) {
		NSMutableArray *stringsForKey = [_components objectForKey:key];
		if (stringsForKey) {
			[stringsForKey addObject:[string copy]];
		} else {
			[_components setObject:[[NSMutableArray alloc] initWithObjects:[string copy], nil] forKey:key];
		}
	}
}

- (void)setString:(NSString *)string forKey:(NSString *)key {
	NSArray *strings = string ? @[ string ] : nil;
	[self setStrings:strings forKey:key];
}

- (void)setStrings:(NSArray *)strings forKey:(NSString *)key {
	if (strings) {
		[_components setObject:[[NSMutableArray alloc] initWithArray:strings copyItems:YES] forKey:key];
	} else {
		[_components removeObjectForKey:key];
	}
}

- (void)removeStringsForKey:(NSString *)key {
	[_components removeObjectForKey:key];
}

@end
