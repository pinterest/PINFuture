//
//  PINTuple.h
//  Pods
//
//  Created by Brandon Kase on 1/17/17.
//
//

// This macro lets you x##y but x and/or y
// can be nested macro calls.
//
// From: 
// http://stackoverflow.com/questions/1872220/is-it-possible-to-iterate-over-arguments-in-variadic-macros
#define PIN_TUPLE_CONCATENATE(x, y) PIN_TUPLE_CONCATENATE1(x, y)
#define PIN_TUPLE_CONCATENATE1(x, y) PIN_TUPLE_CONCATENATE2(x, y)
#define PIN_TUPLE_CONCATENATE2(x, y) x##y

// Apply macro over every two varargs
// PIN_TUPLE_FOR_DOUBLE_EACH : (what: (a, b) -> c, ...args)
// Ported from:
// http://stackoverflow.com/questions/1872220/is-it-possible-to-iterate-over-arguments-in-variadic-macros
#define PIN_TUPLE_FOR_DOUBLE_EACH_0(...)
#define PIN_TUPLE_FOR_DOUBLE_EACH_1(what, x, y, ...) what(x, y)
#define PIN_TUPLE_FOR_DOUBLE_EACH_2(what, x, y, ...)\
  what(x, y) \
  PIN_TUPLE_FOR_DOUBLE_EACH_1(what, __VA_ARGS__)
#define PIN_TUPLE_FOR_DOUBLE_EACH_3(what, x, y, ...)\
  what(x, y) \
  PIN_TUPLE_FOR_DOUBLE_EACH_2(what, __VA_ARGS__)
#define PIN_TUPLE_FOR_DOUBLE_EACH_4(what, x, y, ...)\
  what(x, y) \
  PIN_TUPLE_FOR_DOUBLE_EACH_3(what, __VA_ARGS__)
#define PIN_TUPLE_FOR_DOUBLE_EACH_5(what, x, y, ...)\
  what(x, y) \
  PIN_TUPLE_FOR_DOUBLE_EACH_4(what, __VA_ARGS__)
#define PIN_TUPLE_FOR_DOUBLE_EACH_6(what, x, y, ...)\
  what(x, y) \
  PIN_TUPLE_FOR_DOUBLE_EACH_5(what, __VA_ARGS__)
#define PIN_TUPLE_FOR_DOUBLE_EACH_7(what, x, y, ...)\
  what(x, y) \
  PIN_TUPLE_FOR_DOUBLE_EACH_6(what, __VA_ARGS__)
#define PIN_TUPLE_FOR_DOUBLE_EACH_8(what, x, y, ...)\
  what(x, y) \
  PIN_TUPLE_FOR_DOUBLE_EACH_7(what, __VA_ARGS__)

#define PIN_TUPLE_FOR_DOUBLE_EACH_NARG(...) PIN_TUPLE_FOR_DOUBLE_EACH_NARG_(__VA_ARGS__, PIN_TUPLE_FOR_DOUBLE_EACH_RSEQ_N())
#define PIN_TUPLE_FOR_DOUBLE_EACH_NARG_(...) PIN_TUPLE_FOR_DOUBLE_EACH_ARG_N(__VA_ARGS__)
#define PIN_TUPLE_FOR_DOUBLE_EACH_ARG_N(_0, F0, F01, _1, F1, _2, F2, _3, F3, _4, F4, _5, F5, _6, F6, _7, F7, N, ...) N
#define PIN_TUPLE_FOR_DOUBLE_EACH_RSEQ_N() 8, 8, 7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1, 0

#define PIN_TUPLE_FOR_DOUBLE_EACH_(N, what, ...) PIN_TUPLE_CONCATENATE(PIN_TUPLE_FOR_DOUBLE_EACH_, N)(what, __VA_ARGS__)
#define PIN_TUPLE_FOR_DOUBLE_EACH(what, ...) PIN_TUPLE_FOR_DOUBLE_EACH_(PIN_TUPLE_FOR_DOUBLE_EACH_NARG(__VA_ARGS__), what, __VA_ARGS__)


#define PIN_TUPLE_ONE_PROP(typ, val) \
  @property (nonatomic, strong) typ val ;

#define PIN_TUPLE_ONE_METHOD_PARAM(typ, val) \
  val : (typ)val
  
#define PIN_TUPLE_ASSIGN_PROP(typ, val) \
  self . val = val;

#define PIN_TUPLE_ONE_INIT_ARG(typ, val) \
  val : val

#define PIN_TUPLE(name, typ, val, ...) \
  @interface name : NSObject \
  PIN_TUPLE_FOR_DOUBLE_EACH(PIN_TUPLE_ONE_PROP, typ, val, __VA_ARGS__) \
  -(instancetype)init NS_UNAVAILABLE; \
  -(instancetype)initWith##val : (typ)val \
    PIN_TUPLE_FOR_DOUBLE_EACH(PIN_TUPLE_ONE_METHOD_PARAM, __VA_ARGS__); \
  +(instancetype)newWith##val : (typ)val \
    PIN_TUPLE_FOR_DOUBLE_EACH(PIN_TUPLE_ONE_METHOD_PARAM, __VA_ARGS__); \
  @end
  
#define PIN_TUPLE_IMPL(name, typ, val, ...) \
  @implementation name \
    -(instancetype)initWith##val : (typ)val \
      PIN_TUPLE_FOR_DOUBLE_EACH(PIN_TUPLE_ONE_METHOD_PARAM, __VA_ARGS__) \
      { \
        if (self = [super init]) { \
          PIN_TUPLE_FOR_DOUBLE_EACH(PIN_TUPLE_ASSIGN_PROP, typ, val, __VA_ARGS__) \
        } \
        return self; \
      } \
    +(instancetype)newWith##val : (typ)val \
      PIN_TUPLE_FOR_DOUBLE_EACH(PIN_TUPLE_ONE_METHOD_PARAM, __VA_ARGS__) \
      { \
        return [[ name alloc ] initWith##val : val \
          PIN_TUPLE_FOR_DOUBLE_EACH(PIN_TUPLE_ONE_INIT_ARG, __VA_ARGS__) ]; \
      } \
  @end

/*
PIN_TUPLE(PIAPIResult,
    NSString *, name,
    NSNumber *, val,
    NSURLSessionDataTask *, task
)

PIN_TUPLE_IMPL(PIAPIResult,
    NSString *, name,
    NSNumber *, val,
    NSURLSessionDataTask *, task
)
*/

