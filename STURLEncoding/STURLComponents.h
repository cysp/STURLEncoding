//  Copyright (c) 2013 Scott Talbot. All rights reserved.

#import <Foundation/Foundation.h>


@interface STURLComponents : NSObject <NSCopying,NSMutableCopying>

- (id)initWithString:(NSString *)URLString;
+ (instancetype)componentsWithString:(NSString *)URLString;

@property (nonatomic,copy,readonly) NSString *scheme;
@property (nonatomic,copy,readonly) NSString *user;
@property (nonatomic,copy,readonly) NSString *password;
@property (nonatomic,copy,readonly) NSString *host;
@property (nonatomic,strong,readonly) NSNumber *port;
@property (nonatomic,copy,readonly) NSString *path;
@property (nonatomic,copy,readonly) NSString *query;
@property (nonatomic,copy,readonly) NSString *fragment;

- (NSString *)URLString;
- (NSURL *)URL;

- (BOOL)isEqualToSTURLComponents:(STURLComponents *)other;

@end


@interface STMutableURLComponents : STURLComponents

@property (nonatomic,copy) NSString *scheme;
@property (nonatomic,copy) NSString *user;
@property (nonatomic,copy) NSString *password;
@property (nonatomic,copy) NSString *host;
@property (nonatomic,strong) NSNumber *port;
@property (nonatomic,copy) NSString *path;
@property (nonatomic,copy) NSString *query;
@property (nonatomic,copy) NSString *fragment;

@end
