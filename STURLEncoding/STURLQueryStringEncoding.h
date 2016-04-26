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

NS_ASSUME_NONNULL_BEGIN


@interface STURLQueryStringEncoding : NSObject { }

#pragma mark - Query String Building

+ (NSString *)queryStringFromComponents:(STURLQueryStringComponents *)components NS_SWIFT_NAME(queryString(components:));
+ (NSString *)queryStringFromComponents:(STURLQueryStringComponents *)components keyComparator:(NSComparator)comparator NS_SWIFT_NAME(queryString(components:keyComparator:));


#pragma mark - Query String Decoding

+ (STURLQueryStringComponents * __nullable)componentsFromQueryString:(NSString *)string NS_SWIFT_UNAVAILABLE("");
+ (STURLQueryStringComponents * __nullable)componentsFromQueryString:(NSString *)string error:(NSError * __nullable __autoreleasing * __nullable)error NS_SWIFT_NAME(components(string:));

@end

NS_ASSUME_NONNULL_END
