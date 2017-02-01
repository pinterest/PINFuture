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

PINFuture is an Objective-C implementation of the asynchronous primitive called "Future".  This library differs from other Objective-C implementations of Future primarily because it aims to preserve type safety using Objective-C generics.

### What is a Future?

A Future is a wrapper for "a value that will eventually be ready".

A Future can have one of 3 states and usually begins in the "Pending" state.  "Pending" means that the final value of the Future is not yet known but is currently being computed.  The Future will eventually transition to either a "Fulfilled" state and contain a final value, or transition to a "Rejected" state and contain an error object.  "Fulfilled" and "Rejected" are terminal states, and the value/error of a Future cannot change after the first fulfill or reject transition.

![State diagram for a Future](https://cloud.githubusercontent.com/assets/1527302/21839743/3e2709a2-d78e-11e6-8044-9df62b662fd6.png "State diagram for a Future")

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
- (PINFuture<User *> *)logInWithUsername:(NSString *)username 
                                password:(NSString *)password;
```

#### Chain asynchronous operations
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
PINFuture<Posts *> *postsFuture = [PINFutureMap<User *, Posts *> flatMap:userFuture executor:[PINExecutor main] transform:^PINFuture<Posts *> *(User *user) {
    return [Posts fetchPostsForUser:user];
}];
[postsFuture executor:[PINExecutor main] completion:^{
    [self hideSpinner];
}];
[postsFuture executor:[PINExecutor main] success:^(Posts *posts) {
    // update the UI to show posts
} failure:^(NSError *error) {
    // update the UI to show the error
}];
```

#### Stubbing an async function in a test
Callback style
```objc
OCMStub([fileMock readContentsPath:@"foo.txt" 
                           success:OCMOCK_ANY
                           failure:OCMOCK_ANY]).andDo(^(NSInvocation *invocation) {
    (void)(^successBlock)(NSString *) = nil;
    [invocation getArgument:&successBlock atIndex:3];
    if (successBlock) {
        successBlock(@"fake contents");
    }
});
```

Future style
```objc
OCMStub([fileMock readContentsPath:@"foo.txt"]).andReturn([PINFuture<NSString *> withValue:@"fake contents"]);
```

### Handling values

To access the final value of a Future, register `success` and `failure` callbacks.  If you only want to know when a Future completes (and not the specific value or error), register a `complete` callback.

Callbacks will be *dispatched* in the order that they are registered.  However, depending on your specified `executor`, the blocks might  *execute* in a different order or even execute concurrently.

### Threading model ###

Whenever you pass a callback block you must also pass a required `executor:` parameter.  The `executor` determines where and when your block will be executed.

#### Common values for `executor:`
- `[PINExecutor main]` Executes a block on the Main GCD queue.
- `[PINExecutor background]` Executes a block from a pool of background threads.  Careful: With this executor, it's possible that two callback blocks attached to a single future will execute concurrently.

A good rule of thumb: Use `[PINExecutor background]` if work that your callback block does is thread-safe *and* if the work doesn't need to be executed from the Main thread (e.g. because it's touching UIKit).

### Preserving type safety

PINFuture makes use of Objective-C generics to maintain the same type safety that you'd have with callbacks.

```objc
[PINFuture<NSNumber *> withValue:@"foo"]; // Compile error.  Good!
```

In Objective-C, type parameters are optional.  It's a good practice to always specify them for a PINFuture.
```objc
[PINFuture withValue:@"foo"]; // This compiles but will likely blow up with "unrecognized selector" when the value is used.
```

### Blocking on a result

PINFuture is non-blocking and provides no mechanism for blocking.  Blocking a thread on the computation of an async value is generally not a good practice, but is possible using [Grand Central Dispatch Semaphores](http://www.g8production.com/post/76942348764/wait-for-blocks-execution-using-a-dispatch)

### Handling exceptions

PINFuture does not capture Exceptions thrown by callbacks.  On platforms that PINFuture targets, `NSException`s are generally fatal.  PINFuture deals with `NSError`s.

## API Reference

### Constructing

#### `withValue:`
Construct an already-fulfilled Future with a value.
```objc
PINFuture<NSString *> stringFuture = [PINFuture<NSString *> withValue:@"foo"];
```

#### `withError:`
Construct an already-rejected Future with an error.
```objc
PINFuture<NSString *> stringFuture = [PINFuture<NSString *> withError:[NSError errorWithDescription:...]];
```

#### `withBlock:`
Construct a Future and fulfill or reject it by calling one of two callbacks.  This method is generally not safe since because there's no enforcement that your block will call either `resolve` or `reject`.  This is most useful for writing a Future-based wrapper for a Callback-based method.  You'll find this method used extensively in the PINFuture wrappers of Cocoa APIs.
```objc
PINFuture<NSString *> stringFuture = [PINFuture<NSString *> withBlock:^(void (^ fulfill)(NSString *), void (^ reject)(NSError *)) {
    [foo somethingAsyncWithSuccess:resolve failure:reject];
}];
```

#### `executor:block:`
Construct a Future by executing a block that returns a Future.  The most common use case for this is to dispatch some chunk of compute-intensive work off of the the current thread.  You should prefer this method to `withBlock:` whenever you can return a Future because the compiler can enforce that all code paths of your block will return a Future.
```objc
PINFuture<NSNumber *> fibonacciResultFuture = [PINFuture<NSNumber *> executor:[PINExecutor background] block:^PINFuture *() {
    NSInteger *fibonacciResult = [self computeFibonacci:1000000];
    return [PINFuture<NSNumber *> withValue:fibonacciResult];
}];
```

### Transformations
In order to achieve type safety for an operation like `map` that converts from one type of value to another type, we have to jump through some hoops because of Objective-C's rudimentary support for generics.  `map` and `flatMap` are class methods on the class `PINFutureMap`.  The `PINFutureMap` class has two type parameters: `FromType` and `ToType`.

#### Error handling with transformations
- `map` and `flatMap` only preform a transformation is the source Future is *fulfilled*.  If the source Future is *rejected*, then the original error is simply passed through to the return value.
- `mapError` and `flatMapError` only preform a transformation is the source Future is *rejected*.  If the source Future is *fulfilled*, then the original value is simply passed through to the return value.

#### `map`
```objc
PINFuture<NSString *> stringFuture = [PINFutureMap<NSNumber *, NSString *> map:numberFuture executor:[PINExecutor background] transform:^NSString *(NSNumber * number) {
    return [number stringValue];
}];
```

#### `flatMap`
```objc
PINFuture<UIImage *> imageFuture = [PINFutureMap<User *, UIImage *> flatMap:userFuture executor:[PINExecutor background] transform:^PINFuture<NSString *> *(User *user) {
    return [NetworkImageManager fetchImageWithURL:user.profileURL];
}];
```

#### `mapError`
```objc
PINFuture<NSString *> *stringFuture = [File readUTF8ContentsPath:@"foo.txt" encoding:EncodingUTF8];
stringFuture = [fileAFuture executor:[PINExecutor immediate] mapError:^NSString * (NSError *errror) {
    return "";  // If there's any problem reading the file, continue processing as if the file was empty.
}];
```

#### `flatMapError`
```objc
PINFuture<NSString *> *stringFuture = [File readUTF8ContentsPath:@"tryFirst.txt"];
stringFuture = [fileAFuture executor:[PINExecutor background] flatMapError:^PINFuture<NSString *> * (NSError *errror) {
    if ([error isKindOf:[NSURLErrorFileDoesNotExist class]) {
        return [File readUTF8ContentsPath:@"trySecond.txt"];
    } else {
        return [PINFuture withError:error];  // Pass through any other type of error
    }
}];
```

### Gathering
#### `gatherAll`
```objc
NSArray<NSString *> fileNames = @[@"a.txt", @"b.txt", @"c.txt"];
NSArray<PINFuture<NSString *> *> *fileContentFutures = [fileNames map:^ PINFuture<NSString *> *(NSString *fileName) {
    return [File readUTF8ContentsPath:fileName];
}];
PINFuture<NSArray<NSString *> *> *fileContentsFuture = [PINFuture<NSString *> gatherAll:fileContentFutures];
[fileContentsFuture executor:[PINExecutor main] success:^(NSArray<NSString *> *fileContents) {
    // All succceeded.
} failure:^(NSError *error) {
    // One or more failed.  `error` is the first one to fail.
}];
```

### Chaining side-effects (necessary evil)
#### `chainSuccess:failure:`
This is similar to `success:failure` except that a new Future is returned that does not fulfill or reject until the side-effect has been executed.  This should be used sparingly.  It should be rare that you want to have a side-effect, and even rarer to wait on a side-effect.
```objc
// Fetch a user, and return a Future that resolves only after all NotificationCenter observers have been notified.
PINFuture<User *> *userFuture = [self userForUsername:username];
userFuture = [userFuture executor:[PINExecutor main] chainSuccess:^(User *user) {
    [[NSNotifcationCenter sharedCenter] postNotification:kUserUpdated object:user];
} failure:nil;
return userFuture;
```

### Convenience methods (experimental)
#### `executeOnMain`/`executeOnBackground`
We've observed that application code will almost always call with either `executor:[PINExecutor main]` or `executor:[PINExecutor background]`.  For every method that takes an `executor:` there are 2 variations of that method, `executeOnMain` and `executeOnBackground`, that are slightly more concise (shorter by 22 characters).

The following pairs of calls are equivalent.  The second call in each pair demonstrated the convenience method.
```
[userFuture executor:[PINExecutor main] success:success failure:failure];
[userFuture executeOnMainSuccess:success failure:failure];

[userFuture executor:[PINExecutor background] success:success failure:failure];
[userFuture executeOnBackgroundSuccess:success failure:failure];

PINFuture<Post *> *postFuture = [PINFutureMap<User, Post> map:userFuture executor:[PINExecutor main] transform:transform];
PINFuture<Post *> *postFuture = [PINFutureMap<User, Post> map:userFuture executeOnMainTransform:transform];

PINFuture<Post *> *postFuture = [PINFutureMap<User, Post> map:userFuture executor:[PINExecutor background] transform:transform];
PINFuture<Post *> *postFuture = [PINFutureMap<User, Post> map:userFuture executeOnBackgroundTransform:transform];
```

## Roadmap
- support for cancelling the computation of the value
- Task primitive

## "Future" versus "Callback"
- For a function that returns a Future, the compiler can enforce that a value is returned in all code paths.  With callbacks, there's no way to enforce the convention that all code paths should end by calling exactly one callback.
- A Future guarantees that a callback is never called more than once.  This is a difficult convention to enforce in a function that has the side-effect of calling a callback.
- Being explicit about where callbacks are dispatched prevents unnecessary bottlenecking on the Main Queue compared to functions that take callbacks and always dispatch to Main.

## "Future" versus "Task"
- Future: The value is eagerly computed.  The work of computing the value of the Future will still occur even if there are no consumers of the value.
- Task: The value is not computed until a consumer calls `run`.

## Alternatives

### Swift
- BrightFutures https://github.com/Thomvis/BrightFutures
- PromiseKit https://github.com/mxcl/PromiseKit

### Scala
- Scalaz Task - the missing documentation http://timperrett.com/2014/07/20/scalaz-task-the-missing-documentation/
- Monix https://monix.io/docs/2x/eval/task.html

### Objective-C
- BFTask https://github.com/BoltsFramework/Bolts-ObjC

### Java
- Guava https://github.com/google/guava/wiki/ListenableFutureExplained

### C++
- Folly futures https://github.com/facebook/folly/tree/master/folly/futures https://code.facebook.com/posts/1661982097368498/futures-for-c-11-at-facebook/

### JavaScript
- Pied Piper https://github.com/WeltN24/PiedPiper/blob/master/README.md#promises
- Data.Task https://github.com/folktale/data.task
- fun-task https://github.com/rpominov/fun-task/blob/master/docs/api-reference.md#taskmaprejectedfn

## Other inspiration
- Monix design history https://gist.github.com/alexandru/55a6038c2fe61025d555
- Is Future a worthless abstraction compared to Task?  https://www.reddit.com/r/scala/comments/3zofjl/why_is_future_totally_unusable/  Interesting comment by the author of Monix.
- Easy Performance Wins With Scalaz - http://blog.higher-order.com/blog/2015/06/18/easy-performance-wins-with-scalaz/
- Referential transparency: https://wiki.haskell.org/Referential_transparency
- Difference between a Promise and a Task https://glebbahmutov.com/blog/difference-between-promise-and-task/
- Difference between a future and a task https://github.com/indyscala/scalaz-task-intro/blob/master/presentation.md
- Exection Contexts https://www.cocoawithlove.com/blog/specifying-execution-contexts.html
- ScalaZ Task: The Missing Documenttion http://timperrett.com/2014/07/20/scalaz-task-the-missing-documentation/
- Comparing promises frameworks in different languages http://blog.slaks.net/2015-01-08/comparing-different-languages-promises-frameworks/
- Futures and Promises (mostly useful for the list of implementations) https://en.wikipedia.org/wiki/Futures_and_promises

## Design decisions
These decisions are possibly controversial but deliberate.
- Don't allow chaining of `success:failure:` and `completion:` methods.  A reader could easily be mislead into thinking that the chained operations are guaranteed to execute sequentially.
- Don't expose a `success:` method or a `failure:` method.  We think it's a better for the site of any side-effects to make it explicit that they don't want to handle a value or that they don't want to handle an error by passing a `NULL` argument. 
- Don't implement BrightFutures behavior of "execute callback on Main of it was registered from Main, or execute callback in background if registered from not Main".  We think an explicit executor is better.  With the BrightFuture behavior, a chunk of code copied to another location may not behave properly for very subtle reasons.
- Don't pass `value` and `error` as parameters to the `completion` block.  If a caller needs to consume `value` or `error`, they should be using `success:failure:`.  If they need to execute cleanup code without consuming the value, then `completion` is more appropriate.  If a `value` and an `error` are passed to `completion`, it's very easy for callback code to misinterpret whether the future resolved or rejected.

## Authors
- [Chris Danford](https://github.com/chrisdanford)
- [Brandon Kase](https://github.com/bkase)

## License

Copyright 2016 Pinterest, Inc

PINFuture is available under the MIT license. See the LICENSE file for more info.
