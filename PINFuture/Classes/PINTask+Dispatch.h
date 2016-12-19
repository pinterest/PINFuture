//
//  PINTask+Dispatch.h
//  Pods
//
//  Created by Chris Danford on 12/15/16.
//
//

#import "PINTask.h"
#import "PINExecution.h"

NS_ASSUME_NONNULL_BEGIN

@interface PINTask<ObjectType> (Dispatch)
- (PINTask<ObjectType> *)dispatch:(PINExecutionContext)context __attribute__((warn_unused_result));
- (PINTask<ObjectType> *)dispatchDefault __attribute__((warn_unused_result));
@end

NS_ASSUME_NONNULL_END
