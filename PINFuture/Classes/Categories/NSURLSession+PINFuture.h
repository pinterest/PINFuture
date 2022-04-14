//
//  NSURLSession+PINFuture.h
//  Pods
//
//  Created by Chris Danford on 12/8/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSURLSession.h>

#import <PINFuture/PINNSURLSessionDataTaskAndResult.h>
#import <PINFuture/PINFuture.h>

@class PINNSURLSessionDataTaskAndResult;

NS_ASSUME_NONNULL_BEGIN

@interface NSURLSession (PINFuture)

/**
 * Returns a Future that never rejects.  The value type has an error field.
 * that is set in non-exceptional cases such as 4xx response codes.
 */
- (PINNSURLSessionDataTaskAndResult *)pinfuture_dataTaskWithRequest:(NSURLRequest *)request;

/**
 * Returns a Future that never rejects.  The value type has an error field.
 * that is set in non-exceptional cases such as 4xx response codes.
 */
- (PINNSURLSessionDataTaskAndResult *)pinfuture_dataTaskWithRequest:(NSURLRequest *)request
                                                           priority:(float)priority;

@end

NS_ASSUME_NONNULL_END
