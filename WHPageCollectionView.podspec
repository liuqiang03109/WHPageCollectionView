#
# Be sure to run `pod lib lint WHPageCollectionView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'WHPageCollectionView'
s.version          = '0.1.1'
s.summary          = 'WHPageCollectionView'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = <<-DESC
这是一个选项卡控件，可以是全屏的选项卡，也可以是QQ、微信表情的选项卡  WHPageCollectionView
DESC

s.homepage         = 'https://github.com/liuqiang03109/WHPageCollectionView'
# s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'wenhe-liu' => 'liu.wen.he@chrjdt.com' }
s.source           = { :git => 'https://github.com/liuqiang03109/WHPageCollectionView.git', :tag => s.version.to_s }
# s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

s.ios.deployment_target = '8.0'

s.source_files = 'WHPageCollectionView/Classes/**/*'

# s.resource_bundles = {
#   'WHPageCollectionView' => ['WHPageCollectionView/Assets/*.png']
# }

# s.public_header_files = 'Pod/Classes/**/*.h'
# s.frameworks = 'UIKit', 'MapKit'
# s.dependency 'AFNetworking', '~> 2.3'
end
