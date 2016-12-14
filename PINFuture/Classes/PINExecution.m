//
//  PINExecution.m
//  Pods
//
//  Created by Chris Danford on 12/7/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINExecution.h"

#import <pthread.h>

static inline BOOL isCurrentThreadMain()
{
    return 0 != pthread_main_np();
}

PINExecutionContext PINDefaultThreadingModel()
{
    return isCurrentThreadMain() ? [PINExecution mainQueue] : [PINExecution background];
}

static PINThreadingModel currentThreadingModel = PINDefaultThreadingModel;


@implementation PINExecution

+ (PINExecutionContext)defaultContextForCurrentThread;
{
    return currentThreadingModel();
}

// TODO: If there's demand, enable and test this.
//+ (void)setDefaultThreadingModel:(PINThreadingModel)threadingModel
//{
//    currentThreadingModel = threadingModel;
//}

+ (PINExecutionContext)immediate
{
    return ^(dispatch_block_t block) {
        return block;
    };
}

+ (PINExecutionContext)queue:(dispatch_queue_t)queue
{
    return ^dispatch_block_t(dispatch_block_t block) {
        return ^{
            dispatch_async(queue, block);
        };
    };
}

+ (PINExecutionContext)mainQueue
{
    return [self queue:dispatch_get_main_queue()];
}

+ (PINExecutionContext)background
{
    return [self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

@end
