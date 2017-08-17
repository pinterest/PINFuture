//
//  PINError.h
//  Pods
//
//  Created by Chris Danford on 8/11/17.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PINFutureError : NSObject
+ (NSError *)errorWithReason:(NSString *)reason;
@end

NS_ASSUME_NONNULL_END
