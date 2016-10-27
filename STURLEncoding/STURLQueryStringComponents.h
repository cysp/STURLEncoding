//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2012-2016 Scott Talbot.
//

#import <Foundation/Foundation.h>


typedef NS_OPTIONS(NSUInteger, STURLQueryStringComponentsDictionaryRepresentationOptions) {
	STURLQueryStringComponentsDictionaryRepresentationNone = 0,
	STURLQueryStringComponentsDictionaryRepresentationUseFirstValue = (1UL << 0),
};


@interface STURLQueryStringComponents : NSObject<NSCopying,NSMutableCopying>
+ (instancetype __nonnull)components;
+ (instancetype __nullable)componentsWithDictionary:(NSDictionary<NSString *, id> * __nonnull)dict;
- (instancetype __nullable)initWithDictionary:(NSDictionary<NSString *, id> * __nonnull)dict NS_DESIGNATED_INITIALIZER;
@property (nonatomic,copy,nonnull,readonly) NSArray<NSString *> *allKeys;
- (BOOL)containsKey:(NSString * __nonnull)key;
- (NSString * __nullable)stringForKey:(NSString * __nonnull)key;
- (NSArray<NSString *> * __nullable)stringsForKey:(NSString * __nonnull)key;
- (id __nullable)objectForKeyedSubscript:(NSString * __nonnull)key;
- (NSDictionary<NSString *, id> * __nonnull)dictionaryRepresentation;
- (NSDictionary<NSString *, id> * __nonnull)dictionaryRepresentationWithOptions:(STURLQueryStringComponentsDictionaryRepresentationOptions)options;
@end

@interface STMutableURLQueryStringComponents : STURLQueryStringComponents
- (void)setString:(NSString * __nullable)string forKey:(NSString * __nonnull)key;
- (void)addString:(NSString * __nonnull)string forKey:(NSString * __nonnull)key;
- (void)setStrings:(NSArray<NSString *> * __nullable)strings forKey:(NSString * __nonnull)key;
- (void)removeStringsForKey:(NSString * __nonnull)key;
- (void)setObject:(id __nullable)object forKeyedSubscript:(NSString * __nonnull)key;
@end
