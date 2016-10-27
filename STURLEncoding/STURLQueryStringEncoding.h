//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2012-2016 Scott Talbot.
//

#import <Foundation/Foundation.h>

#import <STURLEncoding/STURLQueryStringComponents.h>


typedef NS_OPTIONS(NSUInteger, STURLQueryStringEncodingOptions) {
	STURLQueryStringEncodingOptionsBareDuplicateKeys = (1UL << 0),
};


typedef NSComparisonResult(^STURLQueryStringEncodingKeyComparator)(NSString * __nonnull a, NSString * __nonnull b);


@interface STURLQueryStringEncoding : NSObject

#pragma mark - Query String Building

+ (NSString * __nonnull)queryStringFromComponents:(STURLQueryStringComponents * __nonnull)components;
+ (NSString * __nonnull)queryStringFromComponents:(STURLQueryStringComponents * __nonnull)components keyComparator:(STURLQueryStringEncodingKeyComparator __nullable)keyComparator;
+ (NSString * __nonnull)queryStringFromComponents:(STURLQueryStringComponents * __nonnull)components options:(STURLQueryStringEncodingOptions)options;
+ (NSString * __nonnull)queryStringFromComponents:(STURLQueryStringComponents * __nonnull)components options:(STURLQueryStringEncodingOptions)options keyComparator:(STURLQueryStringEncodingKeyComparator __nullable)keyComparator;


#pragma mark - Query String Decoding

+ (STURLQueryStringComponents * __nullable)componentsFromQueryString:(NSString * __nonnull)string;
+ (STURLQueryStringComponents * __nullable)componentsFromQueryString:(NSString * __nonnull)string error:(NSError * __nullable __autoreleasing * __nullable)error;

@end
