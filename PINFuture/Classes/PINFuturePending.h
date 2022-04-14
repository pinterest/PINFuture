//
//  PINFuturePending.h
//  Pods
//
//  Created by Ray Cho on 2/20/20.
//

#import <PINFuture/PINFutureDefinition.h>

@interface PINFuturePending<ObjectType> : NSObject

- (instancetype)init;

- (PINFuture<ObjectType> *)future;

- (void)fulfillWithValue:(ObjectType)value;
- (void)rejectWithError:(NSError *)error;

@end
