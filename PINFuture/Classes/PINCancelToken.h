//
// Created by Brandon Kase on 12/21/16.
//

#import <Foundation/Foundation.h>

#import "PINExecutor.h"

typedef dispatch_block_t PINCancellationBlock;

@interface PINCancelToken : NSObject

+(PINCancelToken *)fold:(NSArray<PINCancelToken *> *)tokens;

-(PINCancelToken *)initWithExecutor:(id<PINExecutor>)executor andBlock:(PINCancellationBlock)block;

-(PINCancelToken *)and:(PINCancelToken *)other;

-(void)cancel;

@end

// TODO: Why doesn't this work?
// static PINCancelToken * PINCancelTokenIdentity = [[PINCancelToken alloc] initWithContext:[PINExecution immediate] andBlock:^{}];
