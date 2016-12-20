//
// Created by Brandon Kase on 12/19/16.
// Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINResult.h"
#import "TestUtil.h"

SpecBegin(PINResultSpec)

describe(@"Result", ^{
    it(@"can be a success and matched", ^{
        NSString * str = stringFixture();
        NSNumber * num1 = numberFixture();
        NSNumber * num2 = numberFixture();
        NSNumber * res = [PINResult2<NSString *, NSNumber *> match:[PINResult<NSString *> succeedWith:str]
                        success:^NSNumber *(NSString *value){
                              return num1;
                          }
                          failure:^NSNumber *(NSError *error){
                              return num2;
                          }];
        expect(res).to.equal(num1);
    });
    
    it(@"can be a failure and matched", ^{
        NSError * err = errorFixture();
        NSNumber * num1 = numberFixture();
        NSNumber * num2 = numberFixture();
        NSNumber * res2 = [PINResult2<NSString *, NSNumber *> match:[PINResult failWith:err]
                           success:^NSNumber *(NSString *value){
                               return num1;
                           }
                           failure:^NSNumber *(NSError *error){
                               return num2;
                           }];
        expect(res2).to.equal(num2);
    });
});

SpecEnd
