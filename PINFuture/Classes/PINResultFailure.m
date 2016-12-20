//
// Created by Brandon Kase on 12/19/16.
// Copyright (c) 2016 Pinterest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PINResultFailure.h"

@interface PINResultFailure ()
@property (nonatomic, strong) NSError *error;
@end

@implementation PINResultFailure

- (PINResultFailure <id> *)initWithError:(NSError *)error {
    if (self == [super init]) {
        self.error = error;
    }
    return self;
}

@end