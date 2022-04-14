//
//  PINFuture+MapToValue.h
//  Pods
//
//  Created by Chris Danford on 12/8/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import <PINFuture/PINFuture.h>

@interface PINFuture<ObjectType> (MapToValue)

+ (PINFuture<ObjectType> *)map:(PINFuture *)future toValue:(ObjectType)value PIN_WARN_UNUSED_RESULT;

@end
