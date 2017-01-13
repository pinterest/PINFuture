//
//  PINExecution.m
//  Pods
//
//  Created by Chris Danford on 12/7/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINExecutor.h"

#import <pthread.h>

NS_ASSUME_NONNULL_BEGIN

static inline BOOL isCurrentThreadMain()
{
    return 0 != pthread_main_np();
}


@interface PINExecutor ()

@property (atomic) void (^executorBlock)(dispatch_block_t);

@end

// This is very hot code path, so cache where we can to avoid creating Executor garbage.
#define SHARED_INSTANCE(Type, constructorBlock) \
    static Type value = nil; \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        value = constructorBlock(); \
    }); \
    return value;

#define SHARED_EXECUTOR(constructorBlock) \
    SHARED_INSTANCE(id<PINExecutor>, constructorBlock);

@implementation PINExecutor

- (instancetype)initWithExecutorBlock:(void (^)(dispatch_block_t))executorBlock
{
    self = [super init];
    if (self) {
        _executorBlock = executorBlock;
    }
    return self;
}

- (void)execute:(dispatch_block_t)block
{
    self.executorBlock(block);
}

+ (id<PINExecutor>)immediate
{
    SHARED_EXECUTOR(^{
        return [[PINExecutor alloc] initWithExecutorBlock:^(dispatch_block_t block) {
            block();
        }];
    });
}

+ (id<PINExecutor>)main
{
    SHARED_EXECUTOR(^{
        return [[PINExecutor alloc] initWithExecutorBlock:^(dispatch_block_t block) {
            if (isCurrentThreadMain()) {
                return [[self immediate] execute:block];
            } else {
                return [[self queue:dispatch_get_main_queue()] execute:block];
            }
        }];
    });
}

+ (id<PINExecutor>)queue:(dispatch_queue_t)queue
{
    return [[PINExecutor alloc] initWithExecutorBlock:^(dispatch_block_t block) {
        dispatch_async(queue, block);
    }];
}

+ (id<PINExecutor>)background
{
    SHARED_EXECUTOR(^{
        return [self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    });
}

@end

NS_ASSUME_NONNULL_END
