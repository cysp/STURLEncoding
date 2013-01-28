//
//  STURLQueryStringEncoding.h
//  STURLEncoding
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2012-2013 Scott Talbot. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STURLQueryStringComponents.h"


@interface STURLQueryStringEncoding : NSObject { }

#pragma mark - Query String Building

+ (NSString *)queryStringFromComponents:(STURLQueryStringComponents *)components;


#pragma mark - Query String Decoding

+ (STURLQueryStringComponents *)componentsFromQueryString:(NSString *)string;
+ (STURLQueryStringComponents *)componentsFromQueryString:(NSString *)string error:(NSError * __autoreleasing *)error;

@end
