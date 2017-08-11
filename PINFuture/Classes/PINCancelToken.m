//
// Created by Brandon Kase on 12/21/16.
//

#import "PINCancelToken.h"
#import "PINExecutor.h"

@interface PINCancelToken ()
    @property (nonatomic, strong) PINCancellationBlock cancellationBlock;
@end

@implementation PINCancelToken {

}

+ (PINCancelToken *)fold:(NSArray<PINCancelToken *> *)tokens {

    // TODO: replace with identity constant
    PINCancelToken * accumulator = [[PINCancelToken alloc] initWithExecutor:[PINExecutor immediate] andBlock:^{}];
    if (tokens == nil) {
        return accumulator;
    }

    for (PINCancelToken * token in tokens) {
        accumulator = [accumulator and:token];
    }
    return accumulator;
}

- (PINCancelToken *)initWithExecutor:(id<PINExecutor>)executor andBlock:(PINCancellationBlock)block {
    if (self = [super init]) {
        self.cancellationBlock = ^{
            [executor execute:^{
                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, block);
            }];
        };
    }
    return self;
}

// TODO: Reconsider parallel cancellation
//       * Downside is an extra async dispatch
- (PINCancelToken *)and:(PINCancelToken *)other {
    if (other == nil) {
        return self;
    }

    __weak typeof(self) weakSelf = self;
    return [[PINCancelToken alloc] initWithExecutor:[PINExecutor immediate] andBlock:^{
        weakSelf.cancellationBlock();
        other.cancellationBlock();
    }];
}

- (void)cancel {
    self.cancellationBlock();
}

@end
