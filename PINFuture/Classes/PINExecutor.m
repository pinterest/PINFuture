//
//  PINExecution.m
//  Pods
//
//  Created by Chris Danford on 12/7/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINExecutor.h"

#import <pthread.h>

static inline BOOL isCurrentThreadMain()
{
    return 0 != pthread_main_np();
}

id<PINExecutor> PINDefaultThreadingModel()
{
    return isCurrentThreadMain() ? [PINExecutor mainQueue] : [PINExecutor background];
}

static PINThreadingModel currentThreadingModel = PINDefaultThreadingModel;


@interface PINExecutor ()

@property (atomic) void (^executorBlock)(dispatch_block_t);

@end


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

+ (id<PINExecutor>)defaultContextForCurrentThread;
{
    return currentThreadingModel();
}

// TODO: If there's demand, enable and test this.
//+ (void)setDefaultThreadingModel:(PINThreadingModel)threadingModel
//{
//    currentThreadingModel = threadingModel;
//}

+ (id<PINExecutor>)immediate
{
    return [[PINExecutor alloc] initWithExecutorBlock:^(dispatch_block_t block) {
        block();
    }];
}

+ (id<PINExecutor>)queue:(dispatch_queue_t)queue
{
    return [[PINExecutor alloc] initWithExecutorBlock:^(dispatch_block_t block) {
        dispatch_async(queue, block);
    }];
}

+ (id<PINExecutor>)mainQueue
{
    return [self queue:dispatch_get_main_queue()];
}

+ (id<PINExecutor>)background
{
    return [self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

@end
