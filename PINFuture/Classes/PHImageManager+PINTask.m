//
//  PHImageManager+PINTask.m
//  Pods
//
//  Created by Chris Danford on 12/15/16.
//  Copyright © 2016 Pinterest. All rights reserved.
//

#import "PHImageManager+PINTask.h"

@implementation PINImageManagerImageDataResult

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

@implementation PHImageManager (PINTask)

- (PINTask<PINImageManagerImageDataResult *> *)requestImageDataForAsset:(PHAsset *)asset options:(nullable PHImageRequestOptions *)options
{
    return [PINTask<PINImageManagerImageDataResult *> create:^PINCancelToken * (void (^ _Nonnull resolve)(PINImageManagerImageDataResult * _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
        [self requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            if (imageData) {
                PINImageManagerImageDataResult *result = [[PINImageManagerImageDataResult alloc] initWithImageData:imageData
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
