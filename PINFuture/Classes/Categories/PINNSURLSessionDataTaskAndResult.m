//
//  PINNSURLSessionDataTaskAndResult.m
//  Pods
//
//  Created by Chris Danford on 9/11/17.
//
//

#import "PINNSURLSessionDataTaskAndResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface PINNSURLSessionDataTaskAndResult ()
@property (nonatomic) NSURLSessionDataTask * task;
@property (nonatomic) PINFuture<PINNSURLSessionDataTaskResult *> * resultFuture;
@end

@implementation PINNSURLSessionDataTaskAndResult

+ (instancetype)resultWithTask:(NSURLSessionDataTask *)task
                  resultFuture:(PINFuture<PINNSURLSessionDataTaskResult *> *)resultFuture
{
    PINNSURLSessionDataTaskAndResult *taskAndResult = [[PINNSURLSessionDataTaskAndResult alloc] init];
    taskAndResult.task = task;
    taskAndResult.resultFuture = resultFuture;
    return taskAndResult;
}

@end

NS_ASSUME_NONNULL_END
