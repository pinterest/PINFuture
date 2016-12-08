#
# Be sure to run `pod lib lint PINFuture.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PINFuture'
  s.version          = '0.3.0'
  s.summary          = 'An Objective C future implementation that aims to provide maximal type safety.'
  s.description      = <<-DESC
An Objective C future implementation that aims to provide maximal type safety.  It sticks close to Promises/A+
conventions.
DESC

  s.homepage         = 'https://github.com/chrisdanford/PINFuture'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Chris Danford' => 'chrisdanford@gmail.com' }
  s.source           = { :git => 'https://github.com/chrisdanford/PINFuture.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/chrisdanford'

  s.ios.deployment_target = '8.0'

  s.source_files = 'PINFuture/Classes/**/*'
  
  # s.resource_bundles = {
  #   'PINFuture' => ['PINFuture/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
