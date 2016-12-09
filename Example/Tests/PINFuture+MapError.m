//
//  PINFuture+MapError.m
//  PINFuture
//
//  Created by Chris Danford on 12/8/16.
//  Copyright © 2016 Chris Danford. All rights reserved.
//

#import "PINFuture.h"
#import "TestUtil.h"

SpecBegin(PINFutureMapErrorSpecs)

describe(@"mapError", ^{

    it(@"resolves if all source promises resolve", ^{
        NSError *error1 = [[NSError alloc] init];
        NSError *error2 = [[NSError alloc] initWithDomain:NSOSStatusErrorDomain code:1 userInfo:nil];
        PINFuture<NSString *> *source = [PINFuture<NSString *> futureWithError:error1];
        PINFuture<NSString *> *mapped = [source mapError:^NSString *(NSError *error) {
            return error2;
        }];
        expectFutureToRejectWith(self, mapped, error2);
    });
});

SpecEnd
