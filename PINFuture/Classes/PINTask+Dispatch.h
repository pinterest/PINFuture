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
- (PINTask<ObjectType> *)dispatch:(PINExecutionContext)context PIN_WARN_UNUSED_RESULT;
- (PINTask<ObjectType> *)dispatchDefault PIN_WARN_UNUSED_RESULT;
@end

NS_ASSUME_NONNULL_END
