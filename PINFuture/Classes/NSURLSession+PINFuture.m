//
//  NSURLSession+PINFuture.m
//  Pods
//
//  Created by Chris Danford on 12/8/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "NSURLSession+PINFuture.h"

@interface PINFutureNSURLSessionDataTaskResult ()
@property (nonatomic) NSData * _Nullable data;
@property (nonatomic) NSURLResponse * _Nullable response;
@property (nonatomic) NSError * _Nullable error;
@end

@implementation PINFutureNSURLSessionDataTaskResult
@end

@implementation NSURLSession (PINFuture)

- (PINPair<NSURLSessionDataTask *, PINFuture<PINFutureNSURLSessionDataTaskResult *> *> *)dataTaskFutureWithRequest:(NSURLRequest *)request;
{
    __block NSURLSessionDataTask *task;
    PINFuture<PINFutureNSURLSessionDataTaskResult *> *future;
    future = [PINFuture<PINFutureNSURLSessionDataTaskResult *> withBlock:^(void (^ _Nonnull resolve)(id _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
        task = [self dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)  {
            PINFutureNSURLSessionDataTaskResult *resolvedData = [[PINFutureNSURLSessionDataTaskResult alloc] init];
            resolvedData.data = data;
            resolvedData.response = response;
            resolvedData.error = error;
            resolve(resolvedData);
        }];
        [task resume];
    }];

    return [PINPair<NSURLSessionDataTask *, PINFuture<PINFutureNSURLSessionDataTaskResult *> *> pairWithFirst:task second:future];
}

@end
