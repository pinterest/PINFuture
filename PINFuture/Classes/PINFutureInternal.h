//
//  PINFutureInternal.h
//  Pinterest
//
//  Created by Chris Danford on 11/23/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * If the current thread is Main, reutrn the Main queue.
 * Otherwise, return the normal priority global queue.
 */
dispatch_queue_t defaultDispatchQueueForCurrentThread(void);

NS_ASSUME_NONNULL_END
