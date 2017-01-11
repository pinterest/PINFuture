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

PINFuture is an Objective C implementation of the asynchronous primitive called "Future".  This library differs from other Objective C implementations of Future primarily beccause it aims to preserve type safety using Objective C generics.

### What is a Future?

A Future is a wrapper for "a value that will eventually be ready to use".

A Future is a state machine that usually begins in a the "Pending" state.  "Pending" means that the final value of the Future is not yet known but is currently in-progress.  The Future will eventually transition to either a "Fulfilled" state and contain a final value, or transition to a "Rejected" state and contain an error.  "Fulfilled" and "Rejected" are terminal states for a Future.

![State diagram for a Future](https://cloud.githubusercontent.com/assets/1527302/21829570/aff25f0c-d74b-11e6-9423-4976fa47bcdb.png "State diagram for a Future")

(diagram from [Cancelable Asynchronous Operations with Promises in JavaScript](https://blog.codecentric.de/en/2015/03/cancelable-async-operations-promises-javascript/) by Ben Ripkens)

Some important properties of Futures:
- The value of a Future is not lazily computed.  If a Future exists, the computation of its value is already in-flight.  Even the eventual value of the Future is never used, it will still be computed.
- A future is read-only.  Once a Future is constructed, its computation has begun and there is no method on Future to *influence* the eventual value - only methods to *get* the eventual value.

### Examples
#### Method signatures
Callback style
```objc
- (void)logInWithUsername:(NSString *)username
                 password:(NSString *)password
                  success:( void (^)(User *user) )successBlock
                  failure:( void (^)(NSError *error) )failureBlock;
```
Future style
```objc
- (PINFuture<User *user> *)logInWithUsername:(NSString *)username 
                                    password:(NSString *)password;
```

#### Chain asynchronous operations and have side-effects at the end
Callback style
```objc
[self showSpinner];
[User logInWithUsername:username password:password success:^(User *user) {
    [Posts fetchPostsForUser:user success:^(Posts *posts) {
        dispatch_async(dispatch_get_main_queue(), ^{
           [self hideSpinner];
            // update the UI to show posts
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideSpinner];
            // update the UI to show the error
        });
    }];
} failure:^(NSError *error) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideSpinner];
        // update the UI to show the error
    });
}];
```
Future style
```objc
[self showSpinner];
PINFuture<User *> *userFuture = [User logInWithUsername:username password:password];
PINFuture<Posts *> *postsFuture = [PINFutureMap<User *, Posts *> flatMap:userFuture executor:[PINExecutor mainQueue] transform:^PINFuture<Posts *> *(User *user) {
    return [Posts fetchPostsForUser:user];
}];
[postsFuture executor:[PINExecutor mainQueue] complete:^{
    [self hideSpinner];
}];
[postsFuture executor:[PINExecutor mainQueue] success:^(Posts *posts) {
    // update the UI to show posts
} failure:^(NSError *error) {
    // update the UI to show the error
}];
```

### Handling values

To access the final value of a Future, register `success` and `failure` callbacks.  If you only want to know when a Future completes (and not the specific value or error), register a `complete` callback.

- Callbacks will be *dispatched* in the order that they are registered.  However, depending on your specified `executor`, the blocks might  *execute* in a different order or even execute concurrently.
- It is not safe to add another callback from within a callback of the same Future.

### Threading model ###

When you register a callback, there is a required `executor:` parameter.  The `executor` determines where and when a callback block will be executed.

#### Common values for `executor:`
- `[PINExecutor mainQueue]` Executes a block on the Main GCD queue.
- `[PINExecutor background]` Executes a block from a background pool of threads.  If multiple callback blocks are attached, it's possible the blocks will execute concurrently.

A good rule of thumb: Always use `[PINExecutor background]` unless your block specifically needs to be executed from the Main thread (e.g. because it's touching UIKit).

### Preserving type safety

PINFuture makes use of Objective C generics to maintain the same type safety that you'd have with callbacks.

```objc
[PINFuture<NSNumber *> succeedWithValue:@"foo"]; // Compile error.  Good!
```

In Objective C, type parameters are optional.  It's a good practice to always specify them for a PINFuture.
```objc
[PINFuture succeedWithValue:@"foo"]; // This compiles but will likely blow up with "unrecognized selector" when the value is used.
```

In order to achieve type safety for an operation like `map` that converts from one type of value to another type, we have to jump through some hoops because of Objective C's rudimentary support for generics.  `map` and `flatMap` are class methods on the class `PINFutureMap`.  The `PINFutureMap` class has two type parameters:  `FromType` and `ToType`.
```objc
PINFuture<NSNumber *> *numberFuture = [PINFuture<NSNumber *> succeedWithValue:@123];
PINFuture<NSString *> *stringFuture = [PINFutureMap<NSNumber *, NSString *> mapValue:numberFuture executor:[PINExecutor immediate] success:^NSString * (NSNumber * number) {
    return [number stringValue];
}];
```

### Recovering from an error

`map` and `flatMap` let you handle errors by transforming them back to successful values.

```objc
```

### Blocking on a result

PINFuture is non-blocking and provides no mechanism for blocking.  Blocking a thread on the computation of an async value is generally not a good practice, but is possible using [Grand Central Dispatch Semaphores](http://www.g8production.com/post/76942348764/wait-for-blocks-execution-using-a-dispatch)

### Errors and exceptions

PINFuture does not capture Exceptions thrown by callbacks.  On platforms that PINFuture targets, `NSException`s are generally fatal.  PINFuture deals with `NSError`s.

## API Reference

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
PINFuture<NSString *> stringFuture = [PINFuture<NSString *> withBlock:^(void (^ resolve)(NSString *), void (^ reject)(NSError *)) {
    [foo somethingAsyncWithSuccess:resolve failure:reject];
}];
```

### Transforming

#### `mapValue`
```objc
PINFuture<NSString *> stringFuture = [PINFutureMap<NSNumber *, NSString *> mapValue:numberFuture executor:[PINExecutor background] transform:^NSString * (NSNumber * number) {
    return [number stringValue];
}];
```

#### `map`
```objc
PINFuture<NSString *> stringFuture = [PINFutureMap<NSNumber *, NSString *> map:numberFuture executor:[PINExecutor background] transform:^NSString * (NSNumber * number) {
    if ([number isEqual:@1]) {
        return [PINResult<NSString *> succeedWith:stringValue];
    } else {
        return [PINResult<NSString *> failWith:[NSError errorWithDescription:@"only supports '1'"]];
    }
}];
```

#### `flatMap`
```objc
PINFuture<NSString *> stringFuture = [PINFutureMap<NSNumber *, NSString *> mapValue:numberFuture executor:[PINExecutor background] transform:^NSString * (NSNumber * number) {
    if ([number isEqual:@1]) {
        return [PINResult<NSString *> succeedWith:stringValue];
    } else {
        return [PINResult<NSString *> failWith:[NSError errorWithDescription:@"only supports '1'"]];
    }
}];
```

### Gathering
#### `gatherAll`
```objc
NSArray<NSString *> fileNames = @[@"a.txt", @"b.txt", @"c.txt"];
NSArray<PINFuture<NSString *> *> *fileContentFutures = [fileNames map:^ PINFuture<NSString *> *(NSString *fileName) {
    return [File readContentsWithPath:fileName];
}];
PINFuture<NSArray<NSString *> *> *fileContentsFuture = [PINFuture<NSString *> gatherAll:fileContentFutures executor:[PINExecutor background]];
[fileContentsFuture executor:[PINExecutor background] success:^(NSArray<NSString *> *fileContents) {
    // All succceeded.
} failure:^(NSError *error) {
    // One or more failed.  `error` is the first one to fail.
}];
```

## Roadmap
- support cancellation
- Task primitive
- "immediateOnMain" execution context https://github.com/Thomvis/BrightFutures/blob/master/Sources/BrightFutures/ExecutionContext.swift#L35

## "Future" versus "Callback"

- For a function that returns a Future, the compiler can enforce that a value is returned in all code paths.  With callbacks, there's no way to enforce the convention that all code paths should end by calling exactly one callback.
- A Future guarantees that a callback is never called more than once.  This is a difficult convention to enforce in a function that has the side-effect of calling a callback.
- Being explicit about where callbacks are dispatched prevents unnecessary bottlenecking on the Main Queue compared to functions that take callbacks and always dispatch to Main.

## "Future" versus "Task"

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

## Design decisions
These decisions are possibly controvercial but deliberate.
- Don't return a value from the `success:failure:` and `completion:` methods that register a callback.  A reader might be mislead into thinking that the callbacks will be executed (not just dispatched) sequentially.
- Don't implement BrightFutures behavior of "execute callback on Main of it was registered from Main, or execute callback in background if registered from not Main".  We think an explicit executor is better.  With the BrightFuture behavior, a chunk of code copied to another location may not behave properly for very subtle reasons.
- Don't pass `value` and `error` as parameters to the `completion` block.  If a caller needs to consume `value` or `error`, they should be using `success:failure:`.  If they need to execute cleanup code without consuming the value, then `completion` is more appropriate.  If a `value` and an `error` are passed to `completion`, it's very easy for callback code to misinterpret whether the future resolved or rejected.

## Author

Chris Danford, chrisdanford@gmail.com

## License

Copyright 2016 Pinterest, Inc

PINFuture is available under the MIT license. See the LICENSE file for more info.
