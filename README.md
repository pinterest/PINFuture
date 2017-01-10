This is a work-in-progress and not ready for public consumption.

# PINFuture

[![CI Status](http://img.shields.io/travis/Chris Danford/PINFuture.svg?style=flat)](https://travis-ci.org/Chris Danford/PINFuture)
[![Version](https://img.shields.io/cocoapods/v/PINFuture.svg?style=flat)](http://cocoapods.org/pods/PINFuture)
[![License](https://img.shields.io/cocoapods/l/PINFuture.svg?style=flat)](http://cocoapods.org/pods/PINFuture)
[![Platform](https://img.shields.io/cocoapods/p/PINFuture.svg?style=flat)](http://cocoapods.org/pods/PINFuture)

## Installation

PINFuture is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod "PINFuture"
```

## Overview

PINFuture is an Objective C implementation of the async primitive called "future" that differs from other Objective C implementations in that it aims to preserve type safety.

### What is a Future?

A Future is a read-only reference to a computation that has already been started but might not yet have finished.

When you write a function that produces an asynchronous value, that function can return a Future instead having 1 or more callback parameters.

Callback style
```objc
- (void)createPinWithImageURL:(NSURL *)imageURL
                      success:(PIPinAPIControllerSuccessBlock)successBlock
                      failure:( void (^)(NSError *error) )failureBlock;
```
Future style
```objc
- (PINFuture<PIPin *> *)createPinWithImageURL:(NSURL *)imageURL;
```

### Handling values ###

You can be informed of the result of a Future by registering callbacks: complete, success and failure.

```objc
PINFuture<PIPin *> *future = [controller createPinWithImageURL:imageURL];
[future executor:[PINExecutor mainQueue] complete:^{
    [LoadingHUD hideSpinner];
}];
[future executor:[PINExecutor mainQueue] success:^(PIPin * _Nonnull pin) {
    [ToastManager showToastForPin:pin];
} failure:^(NSError * _Nonnull error) {
    [LoadingHUD showError:error];
}];
```

The order in which the callbacks are executed upon completion of the future is not guaranteed.  However, it is guaranteed that callbacks will be *dispatched* in the order that they are registered.

It is not safe to add another callback from within a callback of the same Future.

### Threading model ###

When you register a callback, there is a required `executor:` parameter.  An `executor` determines where and when a callback will be executed.  For example:
- On a the Main thread GCD queue (`[PINExecutor mainQueue]`)
- Somewhere on a background thread (`[PINExecutor background]`)
- Immediately when the Future is competed from the thread that completed the future (`[PINExecutor immediate]`).  Don't use this unless your callback is guaranteed to execute super-quickly and with a very high volume.  Your callback may be executed on Main, and you generally don't want any computation to happen on Main that doesn't need to be done specifically there.

For `executor:` you'll almost always specify `[PINExecutor mainQueue]` or `[PINExecutor background]` depending on the needs of your callback.  You should prefer `background` unless something in your callback is needs to be on the Main thread (e.g. touching UIKit in a way that needs to be on Main).

### Preserving type safety

PINFuture makes use of Objective C generics to maintain the same type safety that you'd have with callbacks.

```objc
[PINFuture<NSNumber *> succeedWithValue:@"foo"]; // compile error.  Good.
```

In Objective C, type parameters are optional.  It's a good practice to always specify them for a PINFuture, and ever better if you have tooling that can enforce that a type is always for a `PINFuture`.
```objc
[PINFuture succeedWithValue:@"foo"]; // This compiles but is likely to blow up when a callback uses the value.
```

In order to preserve value type safety for operation that take one type Future and returns a different type of Future, we have to jump through some hoops due to Objective C's rudimentary support for generics.  Any such operation like `map` is implemented as a class method on the `PINFuture2` class.  `PINFuture2` is a class with two type parameters.  The first parameter is the `FromType` and the second is the `ToType`.
```objc
PINFuture<NSNumber *> *numberFuture = [PINFuture<NSNumber *> succeedWithValue:@123];
PINFuture<NSString *> *stringFuture = [PINFuture2<NSNumber *, NSString *> mapValue:numberFuture executor:[PINExecutor immediate] success:^NSString * _Nonnull(NSNumber * _Nonnull number) {
    return [number stringValue];
}];
```

### Chaining and composition
A Future of one type can be transformed (or `map`'d) to a Future of a new type.  Also, functions that return a Future can be composed into higher-level functions that return a Future.

```objc
- (SomeUser *)userForId:(NSUInteger)userId
{
    PINFuture<NSString *> payloadFuture = [httpClient getPath:[NSString stringWithFormat:@"user/%d", userId]];
    return [PINFuture2<NSString *, SomeModel *> map:payloadFuture executor:[PINExecutor background] transform:^PINFuture<SomeUser *> * _Nonnull(NSString * _Nonnull payload) {
        return [self parseUser:payload];
    }];
}
```

### Recovering from an error

`map` and `flatMap` let you handle errors by transforming them back to successful values.

```objc
```

### Blocking on a result

PINFuture is non-blocking and provides no mechanism for blocking.  Blocking a thread on the computation of an async value is generally not a good practice, but is possible using [Grand Central Dispatch Semaphores](http://www.g8production.com/post/76942348764/wait-for-blocks-execution-using-a-dispatch)

### Errors and exceptions

PINFuture does not capture Exceptions thrown by callbacks.  On platforms that PINFuture targets, `NSException`s are generally fatal and `NSError`s are non-exceptional failures.  PINFuture deals with `NSError`s.

## Reference

### Constructing

#### `succeedWith`
Construct an already-resolved Future with a value.
```objc
PINFuture<NSString *> stringFuture = [PINFuture<NSString *> succeedWith:@"foo"];
```

#### `failWith`
Construct an already-rejected Future with an error.
```objc
PINFuture<NSString *> stringFuture = [PINFuture<NSString *> failWith:[NSError errorWithDescription:...]];
```

#### `withBlock`
Construct a Future and resolve or reject it by calling one of two callbacks.  This construct is generally not safe since because your block might not call `resolve` or `reject`.  This is generally only useful for writing a Future-based wrapper for a Callback-based method.
```objc
PINFuture<NSString *> stringFuture = [PINFuture<NSString *> withBlock:^(void (^ _Nonnull resolve)(NSString * _Nonnull), void (^ _Nonnull reject)(NSError * _Nonnull)) {
    [foo somethingAsyncWithSuccess:resolve failure:reject];
}];
```

### Transforming

#### `mapValue`
Use to convert a Future of one ObjectType to a Future of another ObjectType.  `success` is called only if the source future succeeds.  The value returned by `success` populated a new, succeeded future.
```objc
PINFuture<NSString *> stringFuture = [PINFuture2<NSNumber *, NSString *> mapValue:numberFuture executor:[PINExecutor background] transform:^NSString * _Nonnull(NSNumber * _Nonnull number) {
    return [number stringValue];
}];
```

#### `map`
Use to convert a Future of one ObjectType to a Future of another ObjectType.  `success` is called only if the source future succeeds.  The value returned by `success` populated a future.
```objc
PINFuture<NSString *> stringFuture = [PINFuture2<NSNumber *, NSString *> map:numberFuture executor:[PINExecutor background] transform:^NSString * _Nonnull(NSNumber * _Nonnull number) {
    if ([number isEqual:@1]) {
        return [PINResult<NSString *> succeedWith:stringValue];
    } else {
        return [PINResult<NSString *> failWith:[NSError errorWithDescription:@"only supports '1'"]];
    }
}];
```

#### `flatMap`
Use to convert a Future of one ObjectType to a Future of another ObjectType.  `success` is called only if the source future succeeds.  The value returned by `success` becomes the new future.
```objc
PINFuture<NSString *> stringFuture = [PINFuture2<NSNumber *, NSString *> mapValue:numberFuture executor:[PINExecutor background] transform:^NSString * _Nonnull(NSNumber * _Nonnull number) {
    if ([number isEqual:@1]) {
        return [PINResult<NSString *> succeedWith:stringValue];
    } else {
        return [PINResult<NSString *> failWith:[NSError errorWithDescription:@"only supports '1'"]];
    }
}];
```

#### `mapToNull`
```objc
PINFuture<NSString *> *stringFuture = [PINFuture<NSString *> succeedWith:@"foo"];
PINFuture<NSNull *> *futureWithNullValue = [stringFuture mapToNull];
return futureWithNullValue;
```

### Gathering
#### `gatherSome`
#### `gatherAll`

## Roadmap
- support cancellation
- Task primitive
- "immediateOnMain" execution context https://github.com/Thomvis/BrightFutures/blob/master/Sources/BrightFutures/ExecutionContext.swift#L35

## Versus the Callback async primitive

- For a function that returns a Future, the compiler can enforce that a value is returned in all code paths.  With callbacks, there's no way to enforce the convention that all code paths should end by calling exactly one callback.
- A Future guarantees that a callback is never called more than once.  This is a difficult convention to enforce in a function that has the side-effect of calling a callback.
- Being explicit about where callbacks are dispatched prevents unnecessary bottlenecking on the Main Queue compared to functions that take callbacks and always dispatch to Main.

## Versus the Task async primitive

## Alternatives

### Java
- Guava: https://github.com/google/guava/wiki/ListenableFutureExplained

### Scala
- Scalaz Task - the missing documentation http://timperrett.com/2014/07/20/scalaz-task-the-missing-documentation/
- Monix https://monix.io/docs/2x/eval/task.html

- Monix design history https://gist.github.com/alexandru/55a6038c2fe61025d555
- Is Future a worthless abstraction compared to Task?  https://www.reddit.com/r/scala/comments/3zofjl/why_is_future_totally_unusable/  Interesting comment by the author of Monix.
- Easy Performance Wins With Scalaz - http://blog.higher-order.com/blog/2015/06/18/easy-performance-wins-with-scalaz/
- Referential transparency: https://wiki.haskell.org/Referential_transparency
- Difference between a Promise and a Task https://glebbahmutov.com/blog/difference-between-promise-and-task/
- Difference between a future and a task https://github.com/indyscala/scalaz-task-intro/blob/master/presentation.md

#### C++
- Folly futures: https://github.com/facebook/folly/tree/master/folly/futures https://code.facebook.com/posts/1661982097368498/futures-for-c-11-at-facebook/

#### JavaScript
- Pied Piper https://github.com/WeltN24/PiedPiper/blob/master/README.md#promises
- Data.Task https://github.com/folktale/data.task
- fun-task https://github.com/rpominov/fun-task/blob/master/docs/api-reference.md#taskmaprejectedfn

Exection Contexts https://www.cocoawithlove.com/blog/specifying-execution-contexts.html

## Deliberate design decisions
These are possibly controvercial.
- Don't return a value from the `success:failure:` and `completion:` methods that register a callback.  A reader might be mislead into thinking that the callbacks will be executed (not just dispatched) sequentially.
- Don't implement BrightFutures behavior of "execute callback on Main of it was registered from Main, or execute callback in background if registered from not Main".  We think an explicit executor is better.  With the BrightFuture behavior, a chunk of code copied to another location may not behave properly for very subtle reasons.
- Don't pass `value` and `error` as parameters to the `completion` block.  If a caller needs to consume `value` or `error`, they should be using `success:failure:`.  If they need to execute cleanup code without consuming the value, then `completion` is more appropriate.  If a `value` and an `error` are passed to `completion`, it's very easy for callback code to misinterpret whether the future resolved or rejected.

## Author

Chris Danford, chrisdanford@gmail.com

## License

Copyright 2016 Pinterest, Inc

PINFuture is available under the MIT license. See the LICENSE file for more info.
