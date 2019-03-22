//
//  PINFuture+Delay.m
//  Pinterest
//
//  Created by Chris Danford on 4/16/18.
//

#import "PINFuture+Delay.h"

@implementation PINFuture (Delay)

+ (PINFutureNoValue *)delay:(NSTimeInterval)seconds
{
    return [PINFutureNoValue withBlock:^(void (^_Nonnull resolve)(NSNull *_Nonnull), void (^_Nonnull reject)(NSError *_Nonnull)) {

        // Ideally, we'd dispatch to the same dispatch queue that callbacks attached to this future want to be on.
        // Since we can't know that though, we'll choose to dispatch to the background queue.  This queue is more likely
        // to be serviced quickly than tha main queue.
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC), queue, ^{
            resolve([NSNull null]);
        });
    }];
}

@end
