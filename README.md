# PINFuture

[![CI Status](http://img.shields.io/travis/Chris Danford/PINFuture.svg?style=flat)](https://travis-ci.org/Chris Danford/PINFuture)
[![Version](https://img.shields.io/cocoapods/v/PINFuture.svg?style=flat)](http://cocoapods.org/pods/PINFuture)
[![License](https://img.shields.io/cocoapods/l/PINFuture.svg?style=flat)](http://cocoapods.org/pods/PINFuture)
[![Platform](https://img.shields.io/cocoapods/p/PINFuture.svg?style=flat)](http://cocoapods.org/pods/PINFuture)

## Installation

PINFuture is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "PINFuture"
```

## Overview
### What is a Future?

A Future is a read-only reference to a yet-to-be-computed value (or error if the operation fails).

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

To get at the value of a Future, you register one or more callbacks that will be executed when the Future resolves (i.e. succeeds) or rejects (i.e. fails).  You can register a success, failure, complete, any combination of the 3.

```objc
PINFuture<PIPin *> *future = [controller createPinWithImageURL:imageURL];
[future executor:[PINExecutor mainQueue] complete:^{
	[PILoadingHUD dismiss:[error descriptionForHUD]];
}];
[future executor:[PINExecutor mainQueue] success:^(PIPin * _Nonnull pin) {
    [self dismissViewController];
} failure:^(NSError * _Nonnull error) {
    [PILoadingHUD showErrorWithStatus:[error descriptionForHUD]];
}];
```

### Callback execution context ###

When you register a callback, there is a required `executor:` parameter.  An `executor` determines where and how a callback will be executed (e.g. on a background GCD queue, new thread, in a pooled thread or in the current thread (although executing the computation in the current thread is discouraged – more on that below).

This will usually be either `[PINExecutor mainQueue]` or `[PINExecutor background]` depending on the needs of your callback.  You should prefer `background` unless something in your callback is needs to be on the Main thread.

A Future can be `map`'d to a Future of a new type, and operations on futures can be composed into higher-level functions that return Futures.

```objc
- (SomeUser *)userForId:(NSUInteger)userId
{
    PINFuture<NSString *> payloadFuture = [httpSession getPath:[NSString stringWithFormat:@"user/%d", userId]];
    return [PINFuture2<NSDictionary *, SomeModel *> map:payloadFuture executor:[PINExecutor background] success:^PINFuture<SomeUser *> * _Nonnull(NSString * _Nonnull payload) {
        return [self parseUser:payload];
    }];
}
```

### Preserving type safety

PINFuture makes use of Objective C generics to maintain the same type safety that you'd have with callbacks.

```objc
[PINFuture<NSNumber *> succeedWithValue:@"foo"]; // error!
```

In Objective C, type parameters are optional.  It's a good practice to always specify them, and ever better if you have tooling that can enforce that a type is always specified for a `PINFuture` type expression.
```objc
[PINFuture succeedWithValue:@"foo"]; // compiles and probably won't do what you want
```

In order to preserve type safety for operation that take one Future and returns a new type of Future, we have to jump through some hoops due to Objective C's rudimentary support for generics.  Any such operation like `map` is implemented as a class method on the `PINFuture2` class.  `PINFuture2` is a class with two type parameters.  The first parameter is the `FromType` and the second is the `ToType`.
```objc
PINFuture<NSNumber *> *numberFuture = [PINFuture<NSNumber *> succeedWithValue:@123];
PINFuture<NSString *> *stringFuture = [PINFuture2<NSNumber *, NSString *> mapValue:numberFuture executor:[PINExecutor immediate] success:^NSString * _Nonnull(NSNumber * _Nonnull number) {
    return [number stringValue];
}];
```

### Blocking on a result

PINFuture is non-blocking and provides no blocking mechanism.  Blocking is generally not a good practice, but is possible using [Grand Central Dispatch Semaphores](http://www.g8production.com/post/76942348764/wait-for-blocks-execution-using-a-dispatch)

## Reference

## Roadmap
- Cancellation

## Versus the Callback async primitive

- For a function that returns a Future, the compiler can enforce that a value is returned in all code paths.  With callbacks, there's no way to enforce the convention that all code paths should end by calling exactly one callback.
- A Future guarantees that a callback is never called more than once.  This is a difficult convention to enforce in a function that has the side-effect of calling a callback.
- Being explicit about where callbacks are dispatched prevents unnecessary bottlenecking on the Main Queue compared to functions that take callbacks and always dispatch to Main.

## Versus the Task async primitive


## Alternatives


## Future

## Author

Chris Danford, chrisdanford@gmail.com

## License

Copyright 2016 Pinterest, Inc

PINFuture is available under the MIT license. See the LICENSE file for more info.
