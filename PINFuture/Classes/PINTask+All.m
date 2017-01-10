//
//  PINTaskMap+All.m
//  Pods
//
//  Created by Chris Danford on 12/14/16.
//
//

#import "PINTask+All.h"

@implementation PINTask (All)

+ (PINTask<NSArray<id> *> *)all:(NSArray<PINTask<id> *> *)sourceTasks
{
    // A very naive implementation.
    if (sourceTasks.count == 0) {
        return [PINTask<NSArray<id> *> succeedWith:@[]];
    } else {
        return [PINTask<NSArray<id> *> create:^PINCancelToken * (void (^ _Nonnull resolve)(NSArray<id> * _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
            NSMutableArray *resolvedValues = [[NSMutableArray alloc] initWithCapacity:sourceTasks.count];
            for (NSUInteger i = 0; i < sourceTasks.count; i++) {
                [resolvedValues addObject:[NSNull null]];
            }
            __block NSUInteger remaining = sourceTasks.count;
            [sourceTasks enumerateObjectsUsingBlock:^(PINTask<id> * _Nonnull sourceTask, NSUInteger index, BOOL * _Nonnull stop) {
                PINTask<id> *taskWithSideEffects = [sourceTask executor:[PINExecutor immediate] doSuccess:^(id _Nonnull value) {
                    @synchronized (resolvedValues) {
                        resolvedValues[index] = value;
                        remaining = remaining - 1;
                        if (remaining == 0) {
                            resolve(resolvedValues);
                        }
                    }
                } failure:^(NSError * _Nonnull error) {
                    reject(error);
                }];
                [taskWithSideEffects run];
            }];
            return NULL;
        }];
    }
}

@end
