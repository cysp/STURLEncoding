//
//  STURLEncoding.h
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


FOUNDATION_EXPORT double STURLEncodingVersionNumber;
FOUNDATION_EXPORT const unsigned char STURLEncodingVersionString[];


extern NSString * const STURLEncodingErrorDomain;
typedef NS_ENUM(NSUInteger, STURLEncodingErrorCode) {
	STURLEncodingErrorCodeUnknown = 0,
};


@interface STURLEncoding : NSObject { }

#pragma mark - URLEncoding

+ (NSString *)stringByURLEncodingString:(NSString *)string NS_SWIFT_NAME(encode(string:));


#pragma mark - URLDecoding

+ (NSString *)stringByURLDecodingString:(NSString *)string NS_SWIFT_NAME(decode(string:));

@end


NS_ASSUME_NONNULL_END


#import <STURLEncoding/STURLQueryStringEncoding.h>
#import <STURLEncoding/STURLQueryStringComponents.h>
