//
//  ALAssetsLibrary.m
//  Pinterest
//
//  Created by Chris Danford on 11/22/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import "ALAssetsLibrary+PINFuture.h"

NS_ASSUME_NONNULL_BEGIN

@implementation ALAssetsLibrary (PINFuture)

- (PINFuture<ALAsset *> *)pinfuture_assetForURL:(NSURL *)assetURL
{
    return [PINFuture<ALAsset *> withBlock:^(void (^ _Nonnull resolve)(ALAsset * _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
        [self assetForURL:assetURL resultBlock:resolve failureBlock:reject];
    }];
}

@end

NS_ASSUME_NONNULL_END
