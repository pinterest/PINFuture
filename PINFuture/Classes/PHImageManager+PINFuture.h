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
 * Immuable.  Futures need to resolve to a single value, so this struct hold all of the values normally passed to the callback.
 */
@interface PHImageManagerImageDataResult : NSObject

@property (nonatomic) NSData *imageData;
@property (nonatomic) NSString *dataUTI;
@property (nonatomic) UIImageOrientation orientation;
@property (nonatomic) NSDictionary *info;

@end

@interface PHImageManager (PINFuture)

- (PINFuture<PHImageManagerImageDataResult *> *)requestImageDataForAsset:(PHAsset *)asset options:(nullable PHImageRequestOptions *)options;

@end

NS_ASSUME_NONNULL_END
