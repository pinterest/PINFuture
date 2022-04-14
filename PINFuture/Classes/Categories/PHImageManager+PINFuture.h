//
//  PHImageManager+PINFuture.h
//  Pinterest
//
//  Created by Chris Danford on 11/22/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import <Photos/Photos.h>

#import <PINFuture/PINFutureDefinition.h>
#import <PINFuture/PINPHImageManagerImageDataResult.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHImageManager (PINFuture)

- (PINFuture<PINPHImageManagerImageDataResult *> *)pinfuture_requestImageDataForAsset:(PHAsset *)asset options:(nullable PHImageRequestOptions *)options;

@end

NS_ASSUME_NONNULL_END
