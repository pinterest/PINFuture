//
//  PINFuture+Dispatch.m
//  Pods
//
//  Created by Chris Danford on 12/5/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINFuture+Dispatch.h"

@implementation PINFuture (Dispatch)

+ (PINFuture<id> *)dispatchWithContext:(PINExecutionContext)context block:(PINFuture<id> * (^)())block;
{
    return [PINFuture<id> withBlock:^(void (^ _Nonnull resolve)(id _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
        // contextify, and execute
        context(^{
            PINFuture<id> *future = block();
            [future success:^(id  _Nonnull value) {
                resolve(value);
            } failure:^(NSError * _Nonnull error) {
                reject(error);
            }];
        })();
    }];
}

@end
