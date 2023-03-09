#
# Be sure to run `pod lib lint GJJson.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GJJson'
  s.version          = '0.0.2'
  s.summary          = 'The transformation framework between JSON and model.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Convenient and nonintrusive conversion framework between JSON and model.
                       DESC

  s.homepage         = 'https://github.com/gaogee/GJJson'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'gaogee' => 'gaoju_os@163.com' }
  s.source           = { :git => 'https://github.com/gaogee/GJJson.git', :tag => s.version.to_s }
  s.social_media_url = 'https://www.zhihu.com/people/flutter-45-53'

  s.ios.deployment_target = '11.0'

  s.source_files = 'GJJson/Classes/**/*'
  
  # s.resource_bundles = {
  #   'GJJson' => ['GJJson/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
