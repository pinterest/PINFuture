//
//  PHImageManager+PINTask.h
//  Pods
//
//  Created by Chris Danford on 12/15/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import <Photos/Photos.h>

#import "PINTask.h"
#import "PINPHImageManagerImageDataResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface PHImageManager (PINTask)

- (PINTask<PINPHImageManagerImageDataResult *> *)pintask_requestImageDataForAsset:(PHAsset *)asset options:(nullable PHImageRequestOptions *)options PIN_WARN_UNUSED_RESULT;

@end

NS_ASSUME_NONNULL_END
