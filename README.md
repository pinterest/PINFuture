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
What is a Future?  A Future is a read-only reference to a yet-to-be-computed value (or error if the operation fails).

When you write a function that produces an asynchronous value, that function can return a Future instead having 1 or more callback parameters.

### Callback style ###
```objc
- (void)createPinWithImageURL:(NSURL *)imageURL
                      success:(PIPinAPIControllerSuccessBlock)successBlock
                      failure:( void (^)(NSError *error) )failureBlock;
```
### Future style ###
```objc
- (PINFuture<PIPin *> *)createPinWithImageURL:(NSURL *)imageURL;
```

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

When you register a callback, there is a required `executor:` parameter.  This will usually be either `[PINExecutor mainQueue]` or `[PINExecutor background]` depending on the needs of your callback.  You should prefer `background` unless something in your callback is needs to be on the Main thread.

A Future can be `map`'d to a Future of a new type, and operations on futures can be composed into higher-level functions that return Futures.

```objc
- (SomeModel *)modelForId:(NSUInteger)id
{
    PINFuture<NSString *> payloadFuture = [httpSession getPath:[NSString stringWithFormat:@"user/%d", id]];
    return [PINFuture2<NSDictionary *, SomeModel *> map:payloadFuture executor:[PINExecutor background] success:^PINResult<NSString *> * _Nonnull(NSString * _Nonnull payload) {
	      return [self parseModel:payload];
    }];
}
```

## Reference



## Advantages versus callbacks

- For a function that returns a Future, the compiler can enforce that a value is returned in all code paths.  With callbacks, there's no way to enforce the convention that all code paths should end by calling exactly one callback.
- A Future guarantees that a callback is never called more than once.  This is a difficult convention to enforce in a function that has the side-effect of calling a callback.
- Being explicit about where callbacks are dispatched prevents unnecessary bottlenecking on the Main Queue compared to functions that take callbacks and always dispatch to Main.

## Author

Chris Danford, chrisdanford@gmail.com

## License

Copyright 2016 Pinterest, Inc

PINFuture is available under the MIT license. See the LICENSE file for more info.
