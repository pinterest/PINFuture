//
//  PINResult.m
//  Pods
//
//  Created by Brandon Kase on 12/19/16.
//

#import <Foundation/Foundation.h>
#import "PINResult.h"
#import "PINResultSuccess.h"
#import "PINResultFailure.h"

NS_ASSUME_NONNULL_BEGIN

@implementation PINResult

+ (PINResultSuccess <id> *)withValue:(id)value {
    return [[PINResultSuccess alloc] initWithValue:value];
}

+ (PINResultFailure <id> *)withError:(NSError *)error {
    return [[PINResultFailure alloc] initWithError:error];
}

@end

NS_ASSUME_NONNULL_END
