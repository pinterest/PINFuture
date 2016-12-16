//
//  ALAssetsLibrary+PINTask.m
//  Pods
//
//  Created by Chris Danford on 12/15/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import "ALAssetsLibrary+PINTask.h"

@implementation ALAssetsLibrary (PINTask)

- (PINTask<ALAsset *> *)assetTaskForURL:(NSURL *)assetURL
{
    return [PINTask<ALAsset *> new:^PINCancellationBlock _Nullable(void (^ _Nonnull resolve)(ALAsset * _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
        [self assetForURL:assetURL resultBlock:resolve failureBlock:reject];
        return NULL;
    }];
}

@end
