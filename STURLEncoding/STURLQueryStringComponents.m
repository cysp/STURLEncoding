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


static NSString *STEnsureNSString(id<NSObject> obj) {
	if ([obj isKindOfClass:[NSString class]]) {
		return (NSString *)obj;
	}
	return nil;
}

static NSArray *STEnsureNSArray(id<NSObject> obj) {
	if ([obj isKindOfClass:[NSArray class]]) {
		return (NSArray *)obj;
	}
	return nil;
}

static BOOL STURLQueryStringComponentsIsValidArray(NSArray *array) {
	for (id obj in array) {
		if ([obj isKindOfClass:[NSString class]]) {
			continue;
		}

		return NO;
	}

	return YES;
}

static BOOL STURLQueryStringComponentsIsValidDictionary(NSDictionary *dict) {
	__block BOOL isValid = YES;

	[dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		if (![key isKindOfClass:[NSString class]]) {
			isValid = NO, *stop = YES;
			return;
		}

		if ([obj isKindOfClass:[NSString class]]) {
			return;
		}

		if ([obj isKindOfClass:[NSArray class]]) {
			if (!STURLQueryStringComponentsIsValidArray(obj)) {
				isValid = NO, *stop = YES;
				return;
			}
		}

		isValid = NO, *stop = YES;
	}];

	return isValid;
}


@implementation STURLQueryStringComponents {
	@package
	NSMutableDictionary *_components;
}

+ (instancetype)components {
	return [[self alloc] initWithDictionary:nil];
}

+ (instancetype)componentsWithDictionary:(NSDictionary *)dict {
	return [[self alloc] initWithDictionary:dict];
}

- (id)init {
	return [self initWithDictionary:nil];
}
- (id)initWithDictionary:(NSDictionary *)dict {
	if (!STURLQueryStringComponentsIsValidDictionary(dict)) {
		return nil;
	}

	if ((self = [super init])) {
		NSMutableDictionary * const components = _components = [NSMutableDictionary dictionary];

		[dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop __unused) {
			NSString * const string = STEnsureNSString(obj);
			if (string) {
				[components setObject:[[NSMutableArray alloc] initWithObjects:[string copy], nil] forKey:key];
				return;
			}

			NSArray * const strings = STEnsureNSArray(obj);
			if (strings) {
				[components setObject:[[NSMutableArray alloc] initWithArray:strings copyItems:YES] forKey:key];
				return;
			}

			NSAssert(0, @"unreachable", nil);
		}];
	}
	return self;
}

- (id)copyWithZone:(NSZone *)zone {
	STURLQueryStringComponents *other = [[STURLQueryStringComponents allocWithZone:zone] init];
	[_components enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop __unused) {
		NSMutableArray *otherStrings = [[NSMutableArray allocWithZone:zone] initWithArray:obj copyItems:YES];
		[other->_components setObject:otherStrings forKey:key];
	}];
	return other;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
	STMutableURLQueryStringComponents *other = [[STMutableURLQueryStringComponents allocWithZone:zone] init];
	[_components enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop __unused) {
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

- (NSDictionary *)dictionaryRepresentation {
    return [self dictionaryRepresentationWithOptions:0];
}

- (NSDictionary *)dictionaryRepresentationWithOptions:(STURLQueryStringComponentsDictionaryRepresentationOptions)options {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:[_components count]];

    [_components enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSArray *values, BOOL *stop __unused) {
        NSUInteger count = [values count];
        switch (count) {
            case 0:
                dictionary[key] = @"";
                break;
            case 1:
                dictionary[key] = [values objectAtIndex:0];
                break;
            default:
                if (options & STURLQueryStringComponentsDictionaryRepresentationUseFirstValue) {
                    dictionary[key] = [values objectAtIndex:0];
                } else {
                    dictionary[key] = values;
                }
                break;
        }
    }];
    
    return dictionary;
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
