//
//  PHImageManager+PINFuture.m
//  Pinterest
//
//  Created by Chris Danford on 11/22/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import "PHImageManager+PINFuture.h"

@implementation PINPHImageManagerImageDataResult

- (instancetype)initWithImageData:(NSData *)imageData
                          dataUTI:(NSString *)dataUTI
                      orientation:(UIImageOrientation)orientation
                             info:(NSDictionary *)info
{
    if (self = [super init]) {
        _imageData = imageData;
        _dataUTI = dataUTI;
        _orientation = orientation;
        _info = info;
    }
    return self;
}

@end

@implementation PHImageManager (PINFuture)

- (PINFuture<PINPHImageManagerImageDataResult *> *)requestImageDataForAsset:(PHAsset *)asset options:(nullable PHImageRequestOptions *)options
{
    return [PINFuture<PINPHImageManagerImageDataResult *> withBlock:^(void (^ _Nonnull resolve)(PINPHImageManagerImageDataResult * _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
        [self requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            if (imageData) {
                PINPHImageManagerImageDataResult *result = [[PINPHImageManagerImageDataResult alloc] initWithImageData:imageData
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
