//
// Created by Brandon Kase on 12/19/16.
// Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINResultSuccess.h"

@interface PINResultSuccess ()
@property (nonatomic, strong) id value;
@end


@implementation PINResultSuccess

- (PINResultSuccess <id> *)initWithValue:(id)value {
    if (self == [super init]) {
        self.value = value;
    }
    return self;
}

@end