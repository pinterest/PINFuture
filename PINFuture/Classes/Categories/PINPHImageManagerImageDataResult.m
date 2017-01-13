//
//  PINPHImageManagerImageDataResult.m
//  Pods
//
//  Created by Chris Danford on 1/13/17.
//
//

#import "PINPHImageManagerImageDataResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface PINPHImageManagerImageDataResult ()
@property (nonatomic) NSData *imageData;
@property (nonatomic, copy) NSString *dataUTI;
@property (nonatomic) UIImageOrientation orientation;
@property (nonatomic) NSDictionary *info;
@end

@implementation PINPHImageManagerImageDataResult

+ (instancetype)resultWithImageData:(NSData *)imageData
                          dataUTI:(NSString *)dataUTI
                      orientation:(UIImageOrientation)orientation
                             info:(NSDictionary *)info
{
    PINPHImageManagerImageDataResult *result = [[PINPHImageManagerImageDataResult alloc] init];
    result.imageData = imageData;
    result.dataUTI = dataUTI;
    result.orientation = orientation;
    result.info = info;
    return result;
}

@end

NS_ASSUME_NONNULL_END
