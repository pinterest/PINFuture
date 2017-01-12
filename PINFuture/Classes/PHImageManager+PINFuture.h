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
@interface PINPHImageManagerImageDataResult : NSObject

// Exposed consumers of PINFuture to write stubs that return fake data.
- (instancetype)initWithImageData:(NSData *)imageData
                          dataUTI:(NSString *)dataUTI
                      orientation:(UIImageOrientation)orientation
                             info:(NSDictionary *)info;

@property (nonatomic, readonly) NSData *imageData;
@property (nonatomic, copy, readonly) NSString *dataUTI;
@property (nonatomic, readonly) UIImageOrientation orientation;
@property (nonatomic, readonly) NSDictionary *info;

@end

@interface PHImageManager (PINFuture)

- (PINFuture<PINPHImageManagerImageDataResult *> *)requestImageDataForAsset:(PHAsset *)asset options:(nullable PHImageRequestOptions *)options;

@end

NS_ASSUME_NONNULL_END
