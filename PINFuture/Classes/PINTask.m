//
//  PINTask.m
//  Pods
//
//  Created by Chris Danford on 12/12/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINTask.h"

#import "PINFuture.h"
#import "PINOnce.h"

typedef PINCancelToken *(^PINExecuteBlock)(void(^resolve)(id), void(^reject)(NSError *));

PINExecuteBlock resolveOrRejectOnceExecutionBlock(PINExecuteBlock block)
{
    return ^PINCancelToken *(void(^resolve)(id), void(^reject)(NSError *)) {
        PINOnce *once = [[PINOnce alloc] init];
        return block(^(id value) {
            [once performOnce:^{
                resolve(value);
            }];
        }, ^(NSError *error) {
            [once performOnce:^{
                reject(error);
            }];
        });
    };
}

@interface PINTask ()
@property (nonatomic) PINExecuteBlock block;
@property (nonatomic) NSUInteger runCount;
@property (nonatomic) NSArray<NSString *> *callStackSymbols;

@end

@implementation PINTask

+ (PINTask<id> *)create:(PINCancelToken *(^)(void(^resolve)(id), void(^reject)(NSError *)))block
{
    PINTask<id> *task = [[PINTask alloc] init];
    task.block = block;
    task.callStackSymbols = [NSThread callStackSymbols];
    return task;
}

+ (PINTask<id> *)succeedWith:(id)value
{
    return [self create:^PINCancelToken *(void (^ _Nonnull resolve)(id _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
        resolve(value);
        return nil;
    }];
}

+ (PINTask<id> *)failWith:(NSError *)error
{
    return [self create:^PINCancelToken * (void (^ _Nonnull resolve)(id _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
        reject(error);
        return nil;
    }];
}

- (void)dealloc
{
    NSAssert(self.runCount > 0, @"constructed a PINTask but never ran it.");
}

- (PINTask<id> *)executor:(id<PINExecutor>)executor doSuccess:(nullable void(^)(id value))success failure:(nullable void(^)(NSError *error))failure
{
    return [self.class create:^PINCancelToken * (void (^ _Nonnull resolve)(id _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
        return [self runSuccess:^(id value) {
            [executor execute:^{
                if (success != NULL) {
                    success(value);
                }
                resolve(value);
            }];
        } failure:^(NSError *error) {
            [executor execute:^{
                if (failure != NULL) {
                    failure(error);
                }
                reject(error);
            }];
        }];
    }];
}

- (PINCancelToken *)runSuccess:(nullable void(^)(id value))success failure:(nullable void(^)(NSError *error))failure;
{
    self.runCount += 1;
             
    PINExecuteBlock onceBlock = resolveOrRejectOnceExecutionBlock(self.block);
    return onceBlock(^void(id value) {
        if (success != NULL) {
            success(value);
        }
    }, ^void(NSError *error) {
        if (failure != NULL) {
            failure(error);
        }
    });
}

- (PINCancelToken *)run;
{
    return [self runSuccess:NULL failure:NULL];
}

//- (__nullable PINCancellationBlock)runAsyncCompletion:(void(^)(NSError *error, id value))completion;
//{
//    PINExecuteBlock onceBlock = resolveOrRejectOnceExecutionBlock(self.block);
//    return onceBlock(^void(id value) {
//        completion(nil, value);
//    }, ^void(NSError *error) {
//        completion(error, nil);
//    });
//}

@end

@implementation PINTask (Compose)

- (PINTask<NSNull *> *)mapToNull
{
    return [PINTaskMap<id, NSNull *> executor:[PINExecutor immediate] mapToValue:self success:^NSNull *(id fromValue) {
        return [NSNull null];
    }];
}

@end
