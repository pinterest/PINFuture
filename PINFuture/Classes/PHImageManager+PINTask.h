//
//  PHImageManager+PINTask.h
//  Pods
//
//  Created by Chris Danford on 12/15/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import <Photos/Photos.h>

#import "PINTask.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Immutable.  A Task need to resolve to a single value, so this struct hold all of the values normally passed to the callback.
 */
@interface PINImageManagerImageDataResult : NSObject

@property (nonatomic, readonly) NSData *imageData;
@property (nonatomic, copy, readonly) NSString *dataUTI;
@property (nonatomic, readonly) UIImageOrientation orientation;
@property (nonatomic, readonly) NSDictionary *info;

@end

@interface PHImageManager (PINTask)

- (PINTask<PINImageManagerImageDataResult *> *)requestImageDataForAsset:(PHAsset *)asset options:(nullable PHImageRequestOptions *)options;

@end

NS_ASSUME_NONNULL_END
