//
//  PHImageManager+PINFuture.m
//  Pinterest
//
//  Created by Chris Danford on 11/22/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import "PHImageManager+PINFuture.h"

@implementation PHImageManagerImageDataResult

@end

@implementation PHImageManager (PINFuture)

- (PINFuture<PHImageManagerImageDataResult *> *)requestImageDataForAsset:(PHAsset *)asset options:(nullable PHImageRequestOptions *)options
{
    return [PINFuture<PHImageManagerImageDataResult *> withBlock:^(void (^ _Nonnull resolve)(PHImageManagerImageDataResult * _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
        [self requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            if (imageData) {
                PHImageManagerImageDataResult *result = [[PHImageManagerImageDataResult alloc] init];
                result.imageData = imageData;
                result.dataUTI = dataUTI;
                result.orientation = orientation;
                result.info = info;

                resolve(result);
            } else {
                NSString *failureReason = NSLocalizedString(@"Invalid Image Data", @"Failure reason for Invalid Image Data");
                NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                     code:NSFileReadUnknownError
                                                 userInfo:@{NSLocalizedFailureReasonErrorKey : failureReason}];
                reject(error);
            }
        }];
    }];
}

@end
