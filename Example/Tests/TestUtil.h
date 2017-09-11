//
//  TestUtil.h
//  PINFuture
//
//  Created by Chris Danford on 12/4/16.
//  Copyright (c) 2016 Pinterest. All rights reserved.
//

#import "PINFuture.h"

void expectFutureToFulfillWith(id testCase, PINFuture *future, id expectedValue);
void expectFutureToRejectWith(id testCase, PINFuture *future, NSError *expectedError);

NSNumber *numberFixture();
NSString *stringFixture();
NSError *errorFixture();
