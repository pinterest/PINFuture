//
//  PINPair.m
//  Pods
//
//  Created by Chris Danford on 12/8/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINPair.h"

@interface PINPair ()
@property (nonatomic) id first;
@property (nonatomic) id second;
@end

@implementation PINPair

+ (instancetype)pairWithFirst:(id)first second:(id)second
{
    PINPair<id, id> *pair = [[PINPair alloc] init];
    pair.first = first;
    pair.second = second;
    return pair;
}

@end
