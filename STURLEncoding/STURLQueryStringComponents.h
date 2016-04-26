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

NS_ASSUME_NONNULL_BEGIN

#ifndef NS_ERROR_ENUM
# if __has_attribute(ns_error_domain)
#  define NS_ERROR_ENUM(_type, _name, _domain)                                   \
  enum _name : _type _name;                                                    \
  enum __attribute__((ns_error_domain(_domain))) _name : _type
# else
#  define NS_ERROR_ENUM(_type, _name, _domain) NS_ENUM(_type, _name)
# endif
#endif


extern NSString * const STURLQueryStringComponentsErrorDomain;
typedef NS_ERROR_ENUM(NSUInteger, STURLQueryStringComponentsErrorCode, STURLQueryStringComponentsErrorDomain) {
    STURLQueryStringComponentsErrorCodeUnknown = 0,
};


typedef NS_OPTIONS(NSUInteger, STURLQueryStringComponentsDictionaryRepresentationOptions) {
    STURLQueryStringComponentsDictionaryRepresentationUseFirstValue = (1UL << 0),
};


@interface STURLQueryStringComponents : NSObject<NSCopying,NSMutableCopying>
+ (instancetype)components NS_SWIFT_UNAVAILABLE("");
+ (instancetype __nullable)componentsWithDictionary:(NSDictionary<NSString *, id> * __nullable)dict NS_SWIFT_UNAVAILABLE("");
- (instancetype)init;
- (instancetype __nullable)initWithDictionary:(NSDictionary<NSString *, id> * __nullable)dict error:(NSError * __nullable __autoreleasing * __nullable)error NS_DESIGNATED_INITIALIZER;
- (NSArray<NSString *> *)allKeys;
- (BOOL)containsKey:(NSString *)key;
- (NSString * __nullable)stringForKey:(NSString *)key;
- (NSArray<NSString *> * __nullable)stringsForKey:(NSString *)key;
- (id __nullable)objectForKeyedSubscript:(NSString *)key;
- (NSDictionary *)dictionaryRepresentation NS_SWIFT_UNAVAILABLE("");
- (NSDictionary *)dictionaryRepresentationWithOptions:(STURLQueryStringComponentsDictionaryRepresentationOptions)options;
@end

@interface STMutableURLQueryStringComponents : STURLQueryStringComponents
- (void)setString:(NSString * __nullable)string forKey:(NSString *)key;
- (void)addString:(NSString * __nullable)string forKey:(NSString *)key NS_SWIFT_NAME(addString(_:forKey:));
- (void)setStrings:(NSArray * __nullable)strings forKey:(NSString *)key;
- (void)removeStringsForKey:(NSString *)key;
- (void)setObject:(id __nullable)object forKeyedSubscript:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
