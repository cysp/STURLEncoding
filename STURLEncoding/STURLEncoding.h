//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2012-2016 Scott Talbot.
//

#import <Foundation/Foundation.h>


FOUNDATION_EXPORT double STURLEncodingVersionNumber;
FOUNDATION_EXPORT const unsigned char STURLEncodingVersionString[];


extern NSString * __nonnull const kSTURLEncodingErrorDomain;
typedef NS_ENUM(NSUInteger, STURLEncodingErrorCode) {
	STURLEncodingErrorCodeUnknown = 0,
};


@interface STURLEncoding : NSObject

#pragma mark - URLEncoding

+ (NSString * __nonnull)stringByURLEncodingString:(NSString * __nonnull)string NS_SWIFT_NAME(encode(_:));


#pragma mark - URLDecoding

+ (NSString * __nullable)stringByURLDecodingString:(NSString * __nonnull)string NS_SWIFT_NAME(decode(_:));

@end


#import <STURLEncoding/STURLQueryStringEncoding.h>
#import <STURLEncoding/STURLQueryStringComponents.h>
