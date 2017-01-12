//
//  PINFuture+MapError.m
//  PINFuture
//
//  Created by Chris Danford on 12/8/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINFuture.h"
#import "TestUtil.h"

SpecBegin(PINFutureMapErrorSpecs)

describe(@"mapError", ^{
    it(@"can return a new error", ^{
        NSError *error = errorFixture();
        NSString *value = stringFixture();
        PINFuture<NSString *> *source = [PINFuture<NSString *> withError:error];
        PINFuture<NSString *> *mapped = [source executor:[PINExecutor immediate] mapError:^NSString *(NSError *error) {
            return value;
        }];
        expectFutureToFulfillWith(self, mapped, value);
    });
});

SpecEnd
