//
//  PINFutureInternal.m
//  Pinterest
//
//  Created by Chris Danford on 11/23/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import "PINFutureInternal.h"

#import <pthread.h>

static inline BOOL isCurrentThreadMain()
{
    return 0 != pthread_main_np();
}

dispatch_queue_t defaultDispatchQueueForCurrentThread()
{
    if (isCurrentThreadMain()) {
        return dispatch_get_main_queue();
    } else {
        return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
}
