//
//  PINResult2.m
//  Pods
//
//  Created by Brandon Kase on 12/19/16.
//
//

#import "PINResult2.h"
#import "PINResultSuccess.h"
#import "PINResultFailure.h"

@interface PINResultSuccess<ValueType> (private)
@property (nonatomic, strong) id value;
@end

@interface PINResultFailure<ValueType> (private)
@property (nonatomic, strong) NSError *error;
@end

@implementation PINResult2

+ (id)match:(PINResult <id> *)result success:(id (^)(id))success failure:(id (^)(NSError *))failure {
    if ([result isKindOfClass:[PINResultSuccess class]]) {
        return success(((PINResultSuccess *)result).value);
    } else if ([result isKindOfClass:[PINResultFailure class]]) {
        return failure(((PINResultFailure *)result).error);
    } else {
        NSAssert(NO, @"Match error");
        return nil;
    }
}

@end
