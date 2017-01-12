//
//  DispatchTests.m
//  PINFuture
//
//  Created by Chris Danford on 12/5/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

// https://github.com/Specta/Specta

#import "PINFuture.h"

#import "TestUtil.h"

dispatch_queue_t backgroundQueue() {
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
}

SpecBegin(PINFutureDispatchSpecs)

describe(@"dispatch", ^{
    id<PINExecutor> backgroundContext = PINExecutor.background;

    it(@"resolve on background queue", ^{
        NSString *value = stringFixture();
        PINFuture<NSString *> *future = [PINFuture<NSString *> dispatchWithExecutor:backgroundContext block:^PINFuture<NSString *> * _Nonnull{
            return [PINFuture withValue:value];
        }];
        expectFutureToFulfillWith(self, future, value);
    });

    it(@"reject on background queue", ^{
        NSError *error = errorFixture();
        PINFuture<NSString *> *future = [PINFuture<NSString *> dispatchWithExecutor:backgroundContext block:^PINFuture<NSString *> * _Nonnull{
            return [PINFuture withError:error];
        }];
        expectFutureToRejectWith(self, future, error);
    });
});

SpecEnd
