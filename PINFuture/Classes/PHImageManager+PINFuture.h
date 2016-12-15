//
//  PHImageManager+PINFuture.h
//  Pinterest
//
//  Created by Chris Danford on 11/22/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import <Photos/Photos.h>

#import "PINFuture.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Immutable.  Futures need to resolve to a single value, so this struct hold all of the values normally passed to the callback.
 */
@interface PHImageManagerImageDataResult : NSObject

@property (nonatomic, readonly) NSData *imageData;
@property (nonatomic, copy, readonly) NSString *dataUTI;
@property (nonatomic, readonly) UIImageOrientation orientation;
@property (nonatomic, readonly) NSDictionary *info;

@end

@interface PHImageManager (PINFuture)

- (PINFuture<PHImageManagerImageDataResult *> *)requestImageDataForAsset:(PHAsset *)asset options:(nullable PHImageRequestOptions *)options;

@end

NS_ASSUME_NONNULL_END
