//
// Created by Brandon Kase on 12/21/16.
//

#import "PINCancelToken.h"
#import "PINExecution.h"
#import "PINOnce.h"

@interface PINCancelToken ()
    @property (nonatomic, strong) PINCancellationBlock cancellationBlock;
@end

@implementation PINCancelToken {

}

+ (PINCancelToken *)fold:(NSArray<PINCancelToken *> *)tokens {
    
    // TODO: replace with identity constant
    PINCancelToken * accumulator = [[PINCancelToken alloc] initWithContext:[PINExecution immediate] andBlock:^{}];
    if (tokens == nil) {
        return accumulator;
    }

    for (PINCancelToken * token in tokens) {
        accumulator = [accumulator and:token];
    }
    return accumulator;
}

- (PINCancelToken *)initWithContext:(PINExecutionContext)context andBlock:(PINCancellationBlock)block {
    if (self = [super init]) {
        PINOnce *once = [[PINOnce alloc] init];
        self.cancellationBlock = context(^{
            [once performOnce:block];
        });
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
    return [[PINCancelToken alloc] initWithContext:[PINExecution immediate] andBlock:^{
        weakSelf.cancellationBlock();
        other.cancellationBlock();
    }];
}

- (void)cancel {
    self.cancellationBlock();
}

@end
