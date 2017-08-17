//
//  PINError.m
//  Pods
//
//  Created by Chris Danford on 8/11/17.
//
//

#import "PINFutureError.h"

NS_ASSUME_NONNULL_BEGIN

NSString *const PINFutureErrorDomain = @"com.coldbrewlabs.PINFuture";

@implementation PINFutureError

+ (NSError *)errorWithReason:(NSString *)reason
{
    NSMutableDictionary *errorUserInfo = [NSMutableDictionary dictionary];
    
    if ([reason length] > 0) {
        [errorUserInfo setValue:reason forKey:NSLocalizedFailureReasonErrorKey];
    }

    NSError *error = [NSError errorWithDomain:PINFutureErrorDomain
                                         code:0
                                     userInfo:errorUserInfo];
    return error;
}

@end

NS_ASSUME_NONNULL_END
