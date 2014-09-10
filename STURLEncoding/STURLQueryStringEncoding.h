//
//  STURLQueryStringEncoding.h
//  STURLEncoding
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2012-2014 Scott Talbot. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <STURLEncoding/STURLQueryStringComponents.h>


typedef NS_OPTIONS(NSUInteger, STURLQueryStringEncodingOptions) {
    STURLQueryStringEncodingOptionsBareDuplicateKeys = (1UL << 0),
};


@interface STURLQueryStringEncoding : NSObject { }

#pragma mark - Query String Building

+ (NSString *)queryStringFromComponents:(STURLQueryStringComponents *)components;
+ (NSString *)queryStringFromComponents:(STURLQueryStringComponents *)components keyComparator:(NSComparator)keyComparator;
+ (NSString *)queryStringFromComponents:(STURLQueryStringComponents *)components options:(STURLQueryStringEncodingOptions)options;
+ (NSString *)queryStringFromComponents:(STURLQueryStringComponents *)components options:(STURLQueryStringEncodingOptions)options keyComparator:(NSComparator)keyComparator;


#pragma mark - Query String Decoding

+ (STURLQueryStringComponents *)componentsFromQueryString:(NSString *)string;
+ (STURLQueryStringComponents *)componentsFromQueryString:(NSString *)string error:(NSError * __autoreleasing *)error;

@end
