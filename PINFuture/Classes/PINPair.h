//
//  PINPair.h
//  Pods
//
//  Created by Chris Danford on 12/8/16.
//
//

#import <Foundation/Foundation.h>

@interface PINPair<FirstType, SecondType> : NSObject

@property (nonatomic, readonly) FirstType first;
@property (nonatomic, readonly) SecondType second;

+ (instancetype)pairWithFirst:(FirstType)first second:(SecondType)second;

@end
