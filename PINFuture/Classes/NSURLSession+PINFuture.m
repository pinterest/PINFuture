//
//  NSURLSession+PINFuture.m
//  Pods
//
//  Created by Chris Danford on 12/8/16.
//
//

#import "NSURLSession+PINFuture.h"

@interface PINFutureNSURLSessionDataTaskCompletionData ()
@property (nonatomic) NSData * _Nullable data;
@property (nonatomic) NSURLResponse * _Nullable response;
@property (nonatomic) NSError * _Nullable error;
@end

@implementation PINFutureNSURLSessionDataTaskCompletionData
@end

@implementation NSURLSession (PINFuture)

- (PINPair<NSURLSessionDataTask *, PINFuture<PINFutureNSURLSessionDataTaskCompletionData *> *> *)dataTaskAndFutureWithRequest:(NSURLRequest *)request;
{
    __block NSURLSessionDataTask *task;
    PINFuture<PINFutureNSURLSessionDataTaskCompletionData *> *future;
    future = [PINFuture<PINFutureNSURLSessionDataTaskCompletionData *> futureWithBlock:^(void (^ _Nonnull resolve)(id _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
        task = [self dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)  {
            PINFutureNSURLSessionDataTaskCompletionData *resolvedData = [[PINFutureNSURLSessionDataTaskCompletionData alloc] init];
            resolvedData.data = data;
            resolvedData.response = response;
            resolvedData.error = error;
            resolve(resolvedData);
        }];
    }];

    return [PINPair<NSURLSessionDataTask *, PINFuture<PINFutureNSURLSessionDataTaskCompletionData *> *> pairWithFirst:task second:future];
}

@end
