//
//  NSURLSession+PINFuture.m
//  Pods
//
//  Created by Chris Danford on 12/8/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "NSURLSession+PINFuture.h"
#import "PINFutureDefinition.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSURLSession (PINFuture)

- (PINNSURLSessionDataTaskAndResult *)pinfuture_dataTaskWithRequest:(NSURLRequest *)request
{
    return [self pinfuture_dataTaskWithRequest:request priority:NSURLSessionTaskPriorityDefault];
}

- (PINNSURLSessionDataTaskAndResult *)pinfuture_dataTaskWithRequest:(NSURLRequest *)request
                                                           priority:(float)priority
{
    __block NSURLSessionDataTask *task;
    PINFuture<PINNSURLSessionDataTaskResult *> *future;
    future = [PINFuture<PINNSURLSessionDataTaskResult *> withBlock:^(void (^ _Nonnull resolve)(id _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
        task = [self dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)  {
            PINNSURLSessionDataTaskResult *result = [PINNSURLSessionDataTaskResult resultWithData:data response:response error:error];
            resolve(result);
        }];
        task.priority = priority;
        [task resume];
    }];

    return [PINNSURLSessionDataTaskAndResult resultWithTask:task resultFuture:future];
}

@end

NS_ASSUME_NONNULL_END
