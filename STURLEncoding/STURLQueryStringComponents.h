//
//  STURLQueryStringComponents.h
//  STURLEncoding
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2012-2014 Scott Talbot.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, STURLQueryStringComponentsDictionaryRepresentationOptions) {
    STURLQueryStringComponentsDictionaryRepresentationUseFirstValue = (1UL << 0),
};


@interface STURLQueryStringComponents : NSObject<NSCopying,NSMutableCopying>
+ (instancetype)components;
+ (instancetype)componentsWithDictionary:(NSDictionary *)dict;
- (NSArray *)allKeys;
- (BOOL)containsKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key;
- (NSArray *)stringsForKey:(NSString *)key;
- (id)objectForKeyedSubscript:(NSString *)key;
- (NSDictionary *)dictionaryRepresentation;
- (NSDictionary *)dictionaryRepresentationWithOptions:(STURLQueryStringComponentsDictionaryRepresentationOptions)options;
@end

@interface STMutableURLQueryStringComponents : STURLQueryStringComponents
- (void)setString:(NSString *)string forKey:(NSString *)key;
- (void)addString:(NSString *)string forKey:(NSString *)key;
- (void)setStrings:(NSArray *)strings forKey:(NSString *)key;
- (void)removeStringsForKey:(NSString *)key;
- (void)setObject:(id)object forKeyedSubscript:(NSString *)key;
@end
