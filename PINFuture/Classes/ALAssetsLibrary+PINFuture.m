//
//  ALAssetsLibrary.m
//  Pinterest
//
//  Created by Chris Danford on 11/22/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import "ALAssetsLibrary+PINFuture.h"

@implementation ALAssetsLibrary (PINFuture)

- (PINFuture<ALAsset *> *)assetForURL:(NSURL *)assetURL
{
    return [PINFuture<ALAsset *> futureWithBlock:^(void (^ _Nonnull resolve)(ALAsset * _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
        [self assetForURL:assetURL resultBlock:resolve failureBlock:reject];
    }];
}

@end
