objc_library(
  name = "PINFuture",
  hdrs = glob(["PINFuture/Classes/**/*.h"]),
  srcs = glob(["PINFuture/Classes/**/*.m"]),
  includes = [
    "PINFuture/Classes",
    "PINFuture/Classes/Categories",
  ],
  copts = ["-w"],
  sdk_frameworks = [
  	"AssetsLibrary",
  	"Photos"
  ],
  visibility = ["//visibility:public"]
)
