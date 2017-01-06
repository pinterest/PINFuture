//
//  NSURLSession+PINTask.m
//  Pods
//
//  Created by Chris Danford on 12/15/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "NSURLSession+PINTask.h"

@interface PINTaskNSURLSessionDataTaskCompletionData ()
@property (nonatomic) NSData * _Nullable data;
@property (nonatomic) NSURLResponse * _Nullable response;
@property (nonatomic) NSError * _Nullable error;
@end

@implementation PINTaskNSURLSessionDataTaskCompletionData
@end

@implementation NSURLSession (PINTask)

- (PINPair<NSURLSessionDataTask *, PINTask<PINTaskNSURLSessionDataTaskCompletionData *> *> *)taskWithRequest:(NSURLRequest *)request;
{
    __block void (^ _Nonnull finalResolve)(PINTaskNSURLSessionDataTaskCompletionData * _Nonnull);

    NSURLSessionDataTask *dataTask = [self dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)  {
        PINTaskNSURLSessionDataTaskCompletionData *completionData = [[PINTaskNSURLSessionDataTaskCompletionData alloc] init];
        completionData.data = data;
        completionData.response = response;
        completionData.error = error;
        NSAssert(finalResolve != NULL, @"finalResolve should not be nil");
        finalResolve(completionData);
    }];
    
    PINTask<PINTaskNSURLSessionDataTaskCompletionData *> *completionTask = [PINTask<PINTaskNSURLSessionDataTaskCompletionData *> create:^PINCancelToken * (void (^ _Nonnull resolve)(PINTaskNSURLSessionDataTaskCompletionData * _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
        
        // save the resolve block, then call `resume`.
        finalResolve = resolve;
        [dataTask resume];
        
        return [[PINCancelToken alloc] initWithExecutor:[PINExecutor immediate] andBlock:^{
            [dataTask cancel];
        }];
    }];
    
    return [PINPair<NSURLSessionDataTask *, PINTask<PINTaskNSURLSessionDataTaskCompletionData *> *> pairWithFirst:dataTask second:completionTask];
}

@end
