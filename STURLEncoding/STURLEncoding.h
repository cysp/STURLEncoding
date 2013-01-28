//
//  STURLEncoding.h
//  STURLEncoding
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2012-2013 Scott Talbot. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString * const kSTURLEncodingErrorDomain;
typedef NS_ENUM(NSUInteger, STURLEncodingErrorCode) {
	STURLEncodingErrorCodeUnknown = 0,
};


@interface STURLEncoding : NSObject { }

#pragma mark - URLEncoding

+ (NSString *)stringByURLEncodingString:(NSString *)string;


#pragma mark - URLDecoding

+ (NSString *)stringByURLDecodingString:(NSString *)string;

@end
