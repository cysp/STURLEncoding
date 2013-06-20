//  Copyright (c) 2013 Scott Talbot. All rights reserved.

#import "STURLComponents.h"


static NSString * const STURLComponentsRegExpPattern = @""
"^"
"(?:([^:/?#]+):)?"
"(?://(?:([^:/?#]*)(?::([^/?#@]*))?@)?(\\[[0-9:A-Fa-f]+\\]|[^/?#:@]*)(?::([0-9]+))?)?"
"([^?#]+)?"
"(?:\\?([^#]*))?"
"(?:#(.*))?"
"$";

static NSRegularExpression *STURLComponentsRegExp = nil;


static inline bool NSNumbersEqualOrBothNil(NSNumber *a, NSNumber *b) {
	return (!a && !b) || ((a && b) && [a compare:b] == NSOrderedSame);
}

static inline bool NSStringsEqualOrBothNil(NSString *a, NSString *b, NSStringCompareOptions options) {
	return (!a && !b) || ((a && b) && [a compare:b options:options] == NSOrderedSame);
}


@interface STURLComponents () {
@package // provide package-level access so that ivars are visible to STMutableURLComponents
	NSString *_scheme;
	NSString *_user;
	NSString *_password;
	NSString *_host;
	NSNumber *_port;
	NSString *_path;
	NSString *_query;
	NSString *_fragment;
}
@end

@implementation STURLComponents

+ (void)initialize {
	if (self == [STURLComponents class]) {
		NSError *error = nil;
		STURLComponentsRegExp = [[NSRegularExpression alloc] initWithPattern:STURLComponentsRegExpPattern options:0 error:&error];
		NSAssert(STURLComponentsRegExp, @"failed to create regex: %@", error);
	}
}

+ (instancetype)componentsWithString:(NSString *)URLString {
	return [[self alloc] initWithString:URLString];
}

- (id)initWithString:(NSString *)URLString {
	if ((self = [super init])) {
		if (URLString) {
			NSArray * const matches = [STURLComponentsRegExp matchesInString:URLString options:0 range:(NSRange){ .length = [URLString length] }];
			NSTextCheckingResult * const match = [matches lastObject];
			NSRange const schemeRange = [match rangeAtIndex:1];
			NSRange const userRange = [match rangeAtIndex:2];
			NSRange const passwordRange = [match rangeAtIndex:3];
			NSRange const hostRange = [match rangeAtIndex:4];
			NSRange const portRange = [match rangeAtIndex:5];
			NSRange const pathRange = [match rangeAtIndex:6];
			NSRange const queryRange = [match rangeAtIndex:7];
			NSRange const fragmentRange = [match rangeAtIndex:8];
			if (schemeRange.location != NSNotFound) {
				_scheme = [URLString substringWithRange:schemeRange];
			}
			if (userRange.location != NSNotFound) {
				_user = [URLString substringWithRange:userRange];
			}
			if (passwordRange.location != NSNotFound) {
				_password = [URLString substringWithRange:passwordRange];
			}
			if (hostRange.location != NSNotFound) {
				_host = [URLString substringWithRange:hostRange];
			}
			if (portRange.location != NSNotFound) {
				_port = @([[URLString substringWithRange:portRange] integerValue]);
			}
			if (pathRange.location != NSNotFound) {
				_path = [URLString substringWithRange:pathRange];
			}
			if (queryRange.location != NSNotFound) {
				_query = [URLString substringWithRange:queryRange];
			}
			if (fragmentRange.location != NSNotFound) {
				_fragment = [URLString substringWithRange:fragmentRange];
			}
		}
	}
	return self;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<STURLComponents %p> { scheme = %@, user = %@, password = %@, host = %@, port = %@, path = %@, query = %@, fragment = %@ }", self, _scheme, _user, _password, _host, _port, _path, _query, _fragment];
}

- (id)copyWithZone:(NSZone *)zone {
	STURLComponents * const copy = [[STURLComponents allocWithZone:zone] init];
	copy->_scheme = [self.scheme copy];
	copy->_user = [self.user copy];
	copy->_password = [self.password copy];
	copy->_host = [self.host copy];
	copy->_port = self.port;
	copy->_path = [self.path copy];
	copy->_query = [self.query copy];
	copy->_fragment = [self.fragment copy];
	return copy;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
	STMutableURLComponents * const copy = [[STMutableURLComponents allocWithZone:zone] init];
	copy->_scheme = [self.scheme copy];
	copy->_user = [self.user copy];
	copy->_password = [self.password copy];
	copy->_host = [self.host copy];
	copy->_port = self.port;
	copy->_path = [self.path copy];
	copy->_query = [self.query copy];
	copy->_fragment = [self.fragment copy];
	return copy;
}

- (BOOL)isEqual:(id)object {
	if (object == self) {
		return YES;
	}

	if ([object isKindOfClass:[STURLComponents class]]) {
		return [self isEqualToSTURLComponents:object];
	}

	return NO;
}

- (BOOL)isEqualToSTURLComponents:(STURLComponents *)other {
	if (!NSStringsEqualOrBothNil(self.scheme, other.scheme, NSCaseInsensitiveSearch)) {
		return NO;
	}
	if (!NSStringsEqualOrBothNil(self.user, other.user, 0)) {
		return NO;
	}
	if (!NSStringsEqualOrBothNil(self.password, other.password, 0)) {
		return NO;
	}
	if (!NSStringsEqualOrBothNil(self.host, other.host, 0)) {
		return NO;
	}
	if (!NSNumbersEqualOrBothNil(self.port, other.port)) {
		return NO;
	}
	if (!NSStringsEqualOrBothNil(self.path, other.path, 0)) {
		return NO;
	}
	if (!NSStringsEqualOrBothNil(self.query, other.query, 0)) {
		return NO;
	}
	if (!NSStringsEqualOrBothNil(self.fragment, other.fragment, 0)) {
		return NO;
	}

	return YES;
}

- (NSUInteger)hash {
	return [_scheme hash] ^ [_user hash] ^ [_password hash] ^ [_host hash] ^ [_port hash] ^ [_path hash] ^ [_query hash] ^ [_fragment hash];
}


- (NSString *)URLString {
	NSMutableString *URLString = [NSMutableString string];
	NSString * const scheme = self.scheme;
	if ([scheme length]) {
		[URLString appendFormat:@"%@:", scheme];
	}
	NSString * const user = self.user;
	NSString * const password = self.password;
	NSString * const host = self.host;
	if (user || password || host) {
		[URLString appendString:@"//"];
		if ([user length] || [password length]) {
			if ([user length]) {
				[URLString appendString:user];
			}
			if ([password length]) {
				[URLString appendFormat:@":%@", password];
			}
			[URLString appendString:@"@"];
		}
		if ([host length]) {
			[URLString appendString:host];
		}
		NSUInteger const port = [self.port unsignedIntegerValue];
		if (port) {
			[URLString appendFormat:@":%d", (unsigned int)port];
		}
	}
	NSString * const path = self.path;
	if ([path length]) {
		[URLString appendString:path];
	}
	NSString * const query = self.query;
	if ([query length]) {
		[URLString appendFormat:@"?%@", query];
	}
	NSString * const fragment = self.fragment;
	if ([fragment length]) {
		[URLString appendFormat:@"#%@", fragment];
	}
	return [URLString copy];
}

- (NSURL *)URL {
	NSString * const URLString = self.URLString;
	return [NSURL URLWithString:URLString];
}

@end


@implementation STMutableURLComponents

- (void)setScheme:(NSString *)scheme {
	_scheme = [scheme copy];
}

- (void)setUser:(NSString *)user {
	_user = [user copy];
}

- (void)setPassword:(NSString *)password {
	_password = [password copy];
}

- (void)setHost:(NSString *)host {
	_host = [host copy];
}

- (void)setPort:(NSNumber *)port {
	NSInteger const portInteger = [port integerValue];
	if (portInteger < 0) {
		@throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"port must be non-negative" userInfo:nil];
	}
	_port = port;
}

- (void)setPath:(NSString *)path {
	_path = [path copy];
}

- (void)setQuery:(NSString *)query {
	_query = [query copy];
}

- (void)setFragment:(NSString *)fragment {
	_fragment = [fragment copy];
}

@end
