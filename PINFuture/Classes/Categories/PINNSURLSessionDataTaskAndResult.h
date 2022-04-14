//
//  PINNSURLSessionDataTaskAndResult.h
//  Pods
//
//  Created by Chris Danford on 9/11/17.
//
//

#import <Foundation/Foundation.h>

#import <PINFuture/PINFuture.h>
#import <PINFuture/PINNSURLSessionDataTaskResult.h>

NS_ASSUME_NONNULL_BEGIN

@interface PINNSURLSessionDataTaskAndResult : NSObject

@property (nonatomic, readonly) NSURLSessionDataTask * task;
@property (nonatomic, readonly) PINFuture<PINNSURLSessionDataTaskResult *> * resultFuture;

+ (instancetype)resultWithTask:(NSURLSessionDataTask *)task
                  resultFuture:(PINFuture<PINNSURLSessionDataTaskResult *> *)resultFuture;

@end

NS_ASSUME_NONNULL_END
