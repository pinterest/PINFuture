//
//  ALAssetsLibrary+PINTask.m
//  Pods
//
//  Created by Chris Danford on 12/15/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import "ALAssetsLibrary+PINTask.h"

NS_ASSUME_NONNULL_BEGIN

@implementation ALAssetsLibrary (PINTask)

- (PINTask<ALAsset *> *)pintask_assetForURL:(NSURL *)assetURL
{
    return [PINTask<ALAsset *> create:^PINCancelToken * (void (^ _Nonnull resolve)(ALAsset * _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
        [self assetForURL:assetURL resultBlock:resolve failureBlock:reject];
        return NULL;
    }];
}

@end

NS_ASSUME_NONNULL_END
