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

typedef PINCancellationBlock(^PINExecuteBlock)(void(^resolve)(id), void(^reject)(NSError *));

PINExecuteBlock resolveOrRejectOnceExecutionBlock(PINExecuteBlock block)
{
    NSLog(@"PINCancellationBlock 1");
    return ^PINCancellationBlock(void(^resolve)(id), void(^reject)(NSError *)) {
        NSLog(@"PINCancellationBlock 2");
        PINOnce *once = [[PINOnce alloc] init];
        return block(^(id value) {
            NSLog(@"PINCancellationBlock 3a");
            [once performOnce:^{
                NSLog(@"PINCancellationBlock 3b");
                resolve(value);
            }];
        }, ^(NSError *error) {
            NSLog(@"PINCancellationBlock 4a");
            [once performOnce:^{
                NSLog(@"PINCancellationBlock 4b");
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

+ (PINTask<id> *)new:(__nullable PINCancellationBlock(^)(void(^resolve)(id), void(^reject)(NSError *)))block
{
    PINTask<id> *task = [[PINTask alloc] init];
    task.block = block;
    task.callStackSymbols = [NSThread callStackSymbols];
    return task;
}

+ (PINTask<id> *)value:(id)value
{
    return [self new:^PINCancellationBlock _Nullable(void (^ _Nonnull resolve)(id _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
        resolve(value);
        return NULL;
    }];
}

+ (PINTask<id> *)error:(NSError *)error
{
    return [self new:^PINCancellationBlock _Nullable(void (^ _Nonnull resolve)(id _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
        reject(error);
        return NULL;
    }];
}

- (void)dealloc
{
    if (self.runCount <= 0) {
        NSLog(@"chris %@", self.callStackSymbols);
    }
        
    NSAssert(self.runCount > 0, @"constructed a PINTask but never ran it.");
}

- (PINTask<id> *)doSuccess:(nullable void(^)(id value))success failure:(nullable void(^)(NSError *error))failure
{
    return [self.class new:^PINCancellationBlock _Nullable(void (^ _Nonnull resolve)(id _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
        return [self runSuccess:^(id value) {
            if (success != NULL) {
                success(value);
            }
            resolve(value);
        } failure:^(NSError *error) {
            if (failure != NULL) {
                failure(error);
            }
            reject(error);
        }];
    }];
}

- (__nullable PINCancellationBlock)runSuccess:(nullable void(^)(id value))success failure:(nullable void(^)(NSError *error))failure;
{
    self.runCount += 1;
             
    PINExecuteBlock onceBlock = resolveOrRejectOnceExecutionBlock(self.block);
    onceBlock(^void(id value) {
        if (success != NULL) {
            success(value);
        }
    }, ^void(NSError *error) {
        if (failure != NULL) {
            failure(error);
        }
    });
    return NULL;
}

- (__nullable PINCancellationBlock)run;
{
    return [self runSuccess:NULL failure:NULL];
}

//- (__nullable PINCancellationBlock)runAsyncCompletion:(void(^)(NSError *error, id value))completion;
//{
//    PINExecuteBlock onceBlock = resolveOrRejectOnceExecutionBlock(self.block);
//    onceBlock(^void(id value) {
//        completion(nil, value);
//    }, ^void(NSError *error) {
//        completion(error, nil);
//    });
//    return NULL;
//}

@end

@implementation PINTask (Compose)

- (PINTask<NSNull *> *)mapToNull
{
    return [PINTask2<id, NSNull *> map:self success:^id(id fromValue) {
        return [NSNull null];
    }];
}

@end
