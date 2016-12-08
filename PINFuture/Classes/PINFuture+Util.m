//
//  PINFuture+Util.m
//  Pods
//
//  Created by Chris Danford on 12/5/16.
//

#import "PINFuture+Util.h"

#import "PINThen.h"

@implementation PINFuture (Util)

+ (PINFuture<NSArray *> *)all:(NSArray<PINFuture *> *)sourceFutures
{
    // A very naive implementation.
    if (sourceFutures.count == 0) {
        return [PINFuture<NSArray *> futureWithValue:@[]];
    } else {
        PINFuture<NSArray *> *future =  [PINFuture<NSArray *> futureWithBlock:^(void (^ _Nonnull resolve)(id _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
            NSMutableArray *resolvedValues = [[NSMutableArray alloc] initWithCapacity:sourceFutures.count];
            for (NSUInteger i = 0; i < sourceFutures.count; i++) {
                [resolvedValues addObject:[NSNull null]];
            }
            __block NSUInteger remaining = sourceFutures.count;
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            for (NSUInteger i = 0; i < sourceFutures.count; i++) {
                PINFuture *sourceFuture = sourceFutures[i];
                // Dispatch to be off of main.  This work does not need to be on main.
                [sourceFuture context:[PINExecution background]
                            success:^(id  _Nonnull value) {
                                @synchronized (resolvedValues) {
                                    resolvedValues[i] = value;
                                    remaining = remaining - 1;
                                    if (remaining == 0) {
                                        resolve(resolvedValues);
                                    }
                                }
                            }
                            failure:^(NSError * _Nonnull error) {
                                reject(error);
                            }];
            }
        }];
        return future;
    }
};

@end
