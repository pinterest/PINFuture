//
//  PINNSURLSessionDataTaskResult.h
//  Pods
//
//  Created by Chris Danford on 12/8/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSURLSession.h>

NS_ASSUME_NONNULL_BEGIN

@interface PINNSURLSessionDataTaskResult : NSObject

@property (nonatomic, readonly) NSData * _Nullable data;
@property (nonatomic, copy, readonly) NSURLResponse * _Nullable response;
@property (nonatomic, readonly) NSError * _Nullable error;

+ (instancetype)resultWithData:(NSData * _Nullable)data
                      response:(NSURLResponse * _Nullable)response
                         error:(NSError * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
