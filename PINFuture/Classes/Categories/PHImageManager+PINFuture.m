//
//  PHImageManager+PINFuture.m
//  Pinterest
//
//  Created by Chris Danford on 11/22/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import "PHImageManager+PINFuture.h"

NS_ASSUME_NONNULL_BEGIN

@implementation PHImageManager (PINFuture)

- (PINFuture<PINPHImageManagerImageDataResult *> *)pinfuture_requestImageDataForAsset:(PHAsset *)asset options:(nullable PHImageRequestOptions *)options
{
    return [PINFuture<PINPHImageManagerImageDataResult *> withBlock:^(void (^ _Nonnull resolve)(PINPHImageManagerImageDataResult * _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
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
    }];
}

@end

NS_ASSUME_NONNULL_END
