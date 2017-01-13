//
//  NSURLSession+PINTask.m
//  Pods
//
//  Created by Chris Danford on 12/15/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "NSURLSession+PINTask.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSURLSession (PINTask)

- (PINPair<NSURLSessionDataTask *, PINTask<PINNSURLSessionDataTaskResult *> *> *)pintask_dataTaskWithRequest:(NSURLRequest *)request;
{
    __block void (^ _Nonnull finalResolve)(PINNSURLSessionDataTaskResult * _Nonnull);

    NSURLSessionDataTask *dataTask = [self dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)  {
        PINNSURLSessionDataTaskResult *result = [PINNSURLSessionDataTaskResult resultWithData:data response:response error:error];
        NSAssert(finalResolve != NULL, @"finalResolve should not be nil");
        finalResolve(result);
    }];

    PINTask<PINNSURLSessionDataTaskResult *> *completionTask = [PINTask<PINNSURLSessionDataTaskResult *> create:^PINCancelToken * (void (^ _Nonnull resolve)(PINNSURLSessionDataTaskResult * _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {

        // save the resolve block, then call `resume`.
        finalResolve = resolve;
        [dataTask resume];

        return [[PINCancelToken alloc] initWithExecutor:[PINExecutor immediate] andBlock:^{
            [dataTask cancel];
        }];
    }];

    return [PINPair<NSURLSessionDataTask *, PINTask<PINNSURLSessionDataTaskResult *> *> pairWithFirst:dataTask second:completionTask];
}

@end

NS_ASSUME_NONNULL_END
