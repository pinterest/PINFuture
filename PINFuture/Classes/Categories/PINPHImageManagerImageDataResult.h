//
//  PINPHImageManagerImageDataResult.h
//  Pods
//
//  Created by Chris Danford on 1/13/17.
//
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Immutable.  Futures need to resolve to a single value, so this struct hold all of the values normally passed to the callback.
 */
@interface PINPHImageManagerImageDataResult : NSObject

// Exposed consumers of PINFuture to write stubs that return fake data.
+ (instancetype)resultWithImageData:(NSData *)imageData
                            dataUTI:(NSString *)dataUTI
                        orientation:(UIImageOrientation)orientation
                               info:(NSDictionary *)info;

@property (nonatomic, readonly) NSData *imageData;
@property (nonatomic, copy, readonly) NSString *dataUTI;
@property (nonatomic, readonly) UIImageOrientation orientation;
@property (nonatomic, readonly) NSDictionary *info;

@end

NS_ASSUME_NONNULL_END
