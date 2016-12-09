//
//  ALAssetsLibrary.h
//  Pinterest
//
//  Created by Chris Danford on 11/22/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

#import "PINFuture.h"

NS_ASSUME_NONNULL_BEGIN

@interface ALAssetsLibrary (PINFuture)

- (PINFuture<ALAsset *> *)assetForURL:(NSURL *)assetURL;

@end

NS_ASSUME_NONNULL_END
