//
//  PHImageManager+PINTask.m
//  Pods
//
//  Created by Chris Danford on 12/15/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import "PHImageManager+PINTask.h"

NS_ASSUME_NONNULL_BEGIN

@implementation PHImageManager (PINTask)

- (PINTask<PINPHImageManagerImageDataResult *> *)pintask_requestImageDataForAsset:(PHAsset *)asset options:(nullable PHImageRequestOptions *)options
{
    return [PINTask<PINPHImageManagerImageDataResult *> create:^PINCancelToken * (void (^ _Nonnull resolve)(PINPHImageManagerImageDataResult * _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
        [self requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            if (imageData) {
                PINPHImageManagerImageDataResult *result = [PINPHImageManagerImageDataResult resultWithImageData:imageData
                                                                                                         dataUTI:dataUTI
                                                                                                     orientation:orientation
                                                                                                            info:info];
                resolve(result);
            } else {
                NSString *failureReason = NSLocalizedString(@"Invalid Image Data", @"Failure reason for Invalid Image Data");
                NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                     code:NSFileReadUnknownError
                                                 userInfo:@{NSLocalizedFailureReasonErrorKey : failureReason}];
                reject(error);
            }
        }];
        return NULL;
    }];
}

@end

NS_ASSUME_NONNULL_END
