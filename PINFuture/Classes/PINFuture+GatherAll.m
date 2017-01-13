//
//  PINFuture+GatherAll.m
//  Pods
//
//  Created by Chris Danford on 12/5/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINFuture.h"

NS_ASSUME_NONNULL_BEGIN

@implementation PINFuture (GatherAll)

+ (PINFuture<NSArray *> *)gatherAll:(NSArray<PINFuture *> *)sourceFutures
{
    // A very naive implementation.
    if (sourceFutures.count == 0) {
        return [PINFuture<NSArray *> withValue:@[]];
    } else {
        PINFuture<NSArray *> *future =  [PINFuture<NSArray *> withBlock:^(void (^ _Nonnull resolve)(id _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
            NSMutableArray *resolvedValues = [[NSMutableArray alloc] initWithCapacity:sourceFutures.count];
            for (NSUInteger i = 0; i < sourceFutures.count; i++) {
                [resolvedValues addObject:[NSNull null]];
            }
            __block NSUInteger remaining = sourceFutures.count;
            [sourceFutures enumerateObjectsUsingBlock:^(PINFuture * _Nonnull sourceFuture, NSUInteger index, BOOL * _Nonnull stop) {
                // Dispatch to be off of main.  This work does not need to be on main.
                [sourceFuture executor:[PINExecutor background]
                              success:^(id  _Nonnull value) {
                                  @synchronized (resolvedValues) {
                                      resolvedValues[index] = value;
                                      remaining = remaining - 1;
                                      if (remaining == 0) {
                                          resolve(resolvedValues);
                                      }
                                  }
                              }
                              failure:^(NSError * _Nonnull error) {
                                  reject(error);
                              }];
            }];
        }];
        return future;
    }
};

@end

NS_ASSUME_NONNULL_END
