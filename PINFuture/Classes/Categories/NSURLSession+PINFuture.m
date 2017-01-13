//
//  NSURLSession+PINFuture.m
//  Pods
//
//  Created by Chris Danford on 12/8/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "NSURLSession+PINFuture.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSURLSession (PINFuture)

- (PINPair<NSURLSessionDataTask *, PINFuture<PINNSURLSessionDataTaskResult *> *> *)pinfuture_dataTaskWithRequest:(NSURLRequest *)request;
{
    __block NSURLSessionDataTask *task;
    PINFuture<PINNSURLSessionDataTaskResult *> *future;
    future = [PINFuture<PINNSURLSessionDataTaskResult *> withBlock:^(void (^ _Nonnull resolve)(id _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
        task = [self dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)  {
            PINNSURLSessionDataTaskResult *result = [PINNSURLSessionDataTaskResult resultWithData:data response:response error:error];
            resolve(result);
        }];
        [task resume];
    }];

    return [PINPair<NSURLSessionDataTask *, PINFuture<PINNSURLSessionDataTaskResult *> *> pairWithFirst:task second:future];
}

@end

NS_ASSUME_NONNULL_END
