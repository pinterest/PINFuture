//
//  PINDispatchProxyTests.m
//  PINFuture
//
//  Created by Chris Danford on 12/9/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

// https://github.com/Specta/Specta

#import "PINDispatchProxy.h"
#import "TestUtil.h"

@interface TestObject : NSObject
@property (nonatomic, copy) PINFuture *(^block)() ;
@end

@implementation TestObject

- (PINFuture<NSString *> *)futureTest
{
    return self.block();
}

@end

SpecBegin(PINDispatchProxySpecs)

describe(@"dispatchProxy", ^{
    it(@"can dispatch off of main", ^{
        NSString *value = stringFixture();
        TestObject *testObject = [[TestObject alloc] init];
        [testObject setBlock:^PINFuture *{
            expect([NSThread isMainThread]).to.beFalsy();
            return [PINFuture withValue:value];
        }];
        
        id proxy = [PINDispatchProxy proxyWithExecutor:[PINExecutor background] target:testObject];
        PINFuture<NSString *> *future = [proxy futureTest];
        expectFutureToResolveWith(self, future, value);
    });
});

SpecEnd
