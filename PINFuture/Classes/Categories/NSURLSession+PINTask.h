//
//  NSURLSession+PINTask.h
//  Pods
//
//  Created by Chris Danford on 12/15/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSURLSession.h>

#import "PINNSURLSessionDataTaskResult.h"
#import "PINTask.h"
#import "PINPair.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSURLSession (PINTask)

/**
 * Returns a Task that never rejects.  The value type has an error field.
 * that is set in non-exceptional cases such as 4xx response codes.
 */
- (PINPair<NSURLSessionDataTask *, PINTask<PINNSURLSessionDataTaskResult *> *> *)pintask_dataTaskWithRequest:(NSURLRequest *)request;

@end

NS_ASSUME_NONNULL_END
