#
# Be sure to run `pod lib lint PINFuture.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PINFuture'
  s.version          = '5.1.0'
  s.summary          = 'An Objective C implementation of the Future async value pattern that aims to provide maximal type safety.'
  s.description      = <<-DESC
An Objective C implementation of the Future async value pattern that aims to provide maximal type safety.
DESC

  s.homepage         = 'https://github.com/pinterest/PINFuture'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Chris Danford' => 'chrisdanford@gmail.com' }
  s.source           = { :git => 'https://github.com/pinterest/PINFuture.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/PinterestEng'

  s.ios.deployment_target = '8.0'

  s.source_files = 'PINFuture/Classes/**/*'
  s.weak_frameworks = 'Photos'
  s.frameworks = 'Foundation'
end
