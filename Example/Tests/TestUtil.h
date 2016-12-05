//
//  TestUtil.h
//  PINFuture
//
//  Created by Chris Danford on 12/4/16.
//  Copyright © 2016 Chris Danford. All rights reserved.
//

#import "PINFuture.h"

void expectFutureToResolveWith(id testCase, PINFuture *future, id expectedValue);
void expectFutureToRejectWith(id testCase, PINFuture *future, NSError *expectedError);
