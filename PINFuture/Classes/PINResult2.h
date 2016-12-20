//
//  PinResult2.h
//  Pods
//
//  Created by Brandon Kase on 12/19/16.
//
//

#import "PINResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface PINResult2<ValueType, ToType> : NSObject

+ (ToType)match:(PINResult<ValueType> *)result success:(ToType (^)(ValueType value))success failure:(ToType (^)(NSError * error))failure;

@end

NS_ASSUME_NONNULL_END
