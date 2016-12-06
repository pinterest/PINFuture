//
//  PINFuture+Dispatch.m
//  Pods
//
//  Created by Chris Danford on 12/5/16.
//

#import "PINFuture+Dispatch.h"

@implementation PINFuture (Dispatch)

+ (PINFuture<id> *)dispatchWithQueue:(dispatch_queue_t)queue block:(PINFuture<id> * (^)())block;
{
    return [PINFuture futureWithBlock:^(void (^ _Nonnull resolve)(id _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
        dispatch_async(queue, ^{
            PINFuture<id> *future = block();
            [future success:^(id  _Nonnull value) {
                resolve(value);
            } failure:^(NSError * _Nonnull error) {
                reject(error);
            }];
        });
    }];
}

@end
