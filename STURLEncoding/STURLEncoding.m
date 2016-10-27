//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2012-2016 Scott Talbot.
//

#import <STURLEncoding/STURLEncoding.h>


NSString * const kSTURLEncodingErrorDomain = @"STURLEncoding";


@implementation STURLEncoding

#pragma mark - URLEncoding

// The character sets here are from RFC3986

+ (NSString *)stringByURLEncodingString:(NSString *)string {
	NSString *encoded = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
	    (__bridge CFStringRef)string,
	    CFSTR("-.0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz~"),
	    CFSTR("!#$&'()*+,/:;=?@[]"),
	    kCFStringEncodingUTF8);
	return encoded;
}


#pragma mark - URLDecoding

+ (NSString *)stringByURLDecodingString:(NSString *)string {
	string = [string stringByReplacingOccurrencesOfString:@"+" withString:@" "];
	NSString *decoded = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)string, CFSTR(""), kCFStringEncodingUTF8);
	return decoded;
}

@end
