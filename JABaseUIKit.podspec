#
# Be sure to run `pod lib lint JABaseUIKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JABaseUIKit'
  s.version = '0.1.1'
  s.summary          = '基础UI组件库-JABaseUIKit'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC
  s.homepage         = 'https://github.com/enanso/JABaseUIKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lanmemory@163.com' => 'lanmemory@163.com' }
  s.source           = { :git => 'https://github.com/enanso/JABaseUIKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  
  # 支持 swift 版本
  s.swift_version = '5.0'
  # 支持OC版本
  s.ios.deployment_target = '10.0'
  
  # 不考虑文件分层
  s.source_files = 'JABaseUIKit/Classes/**/*'
  # 静态库依赖
  s.static_framework = true
  s.pod_target_xcconfig = { 'VALID_ARCHS' => 'x86_64 armv7 arm64' ,'OTHER_LDFLAGS' => '"-ObjC"'}

  
  #  #  #  #  #  #  #  #  #  #  #  #  #
  #
  #  参考：https://blog.csdn.net/BUG_delete/article/details/100777277
  #  1.图片文件夹，如果资源文件不多，使用s.resources = 'JABaseUIKit/Classes/Resource/*.png'比较方便
  #  2.s.resource_bundles生成的资源文件，会生成一个bundle文件，使用的时候就是要先获取到这个bundle，生成静态库时可避免同名文件重复
  #
  #  #  #  #  #  #  #
  #s.resources = 'JABaseUIKit/Classes/Resource/*.png'
   s.resource_bundles = {
     'JABaseUIKit' => ['JABaseUIKit/Assets/*.png']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  # OC依赖库
  s.dependency 'Masonry'
  s.dependency 'WebViewJavascriptBridge'
  
  # Swift 依赖库
  s.dependency 'SnapKit'
  s.dependency 'SwiftyJSON'
  
end
