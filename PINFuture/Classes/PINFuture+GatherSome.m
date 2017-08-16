//
//  PINFuture+GatherSome.m
//  Pods
//
//  Created by Chris Danford on 8/16/17.
//
//

#import "PINFuture+GatherSome.h"

NS_ASSUME_NONNULL_BEGIN

@implementation PINFuture (GatherSome)

+ (PINFuture<NSArray *> *)gatherSome:(NSArray<PINFuture *> *)sourceFutures
{
    NSMutableArray<PINFuture *> *recoverToNullFutures = [[NSMutableArray<PINFuture *> alloc] init];
    for (PINFuture *future in sourceFutures) {
        PINFuture *recoverToNullFuture = [future executor:[PINExecutor immediate] mapError:^id(NSError *error) {
            return [NSNull null];
        }];
        [recoverToNullFutures addObject:recoverToNullFuture];
    }
    return [PINFuture gatherAll:recoverToNullFutures];
};

@end

NS_ASSUME_NONNULL_END
