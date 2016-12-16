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
- (PINTask<ObjectType> *)dispatch:(PINExecutionContext)context;
- (PINTask<ObjectType> *)dispatchDefault;
@end

NS_ASSUME_NONNULL_END
