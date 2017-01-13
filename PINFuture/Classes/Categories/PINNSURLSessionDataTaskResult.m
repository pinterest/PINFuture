//
//  PINNSURLSessionDataTaskResult.m
//  Pods
//
//  Created by Chris Danford on 1/13/17.
//
//

#import "PINNSURLSessionDataTaskResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface PINNSURLSessionDataTaskResult ()
@property (nonatomic) NSData * _Nullable data;
@property (nonatomic) NSURLResponse * _Nullable response;
@property (nonatomic) NSError * _Nullable error;
@end

@implementation PINNSURLSessionDataTaskResult

+ (instancetype)resultWithData:(NSData * _Nullable)data
                      response:(NSURLResponse * _Nullable)response
                         error:(NSError * _Nullable)error
{
    PINNSURLSessionDataTaskResult *result = [[PINNSURLSessionDataTaskResult alloc] init];
    result.data = data;
    result.response = response;
    result.error = error;
    return result;
}

@end

NS_ASSUME_NONNULL_END
