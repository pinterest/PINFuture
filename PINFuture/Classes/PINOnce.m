//
//  PINOnce.m
//  Pods
//
//  Created by Chris Danford on 12/14/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINOnce.h"

@interface PINOnce ()
@property (nonatomic) NSLock *lock;
@property (nonatomic) BOOL performed;
@end

@implementation PINOnce

+ (instancetype)new
{
    return [[PINOnce alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        _lock = [NSLock new];
        _performed = NO;
    }
    return self;
}

- (void)performOnce:(dispatch_block_t)block
{
    [self.lock lock];
    if (self.performed == NO) {
        self.performed = YES;
        block();
    }
    [self.lock unlock];
}

@end
