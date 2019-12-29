#
# Be sure to run `pod lib lint CalendarScrollView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CalendarScrollView'
  s.version          = '0.1.1'
  s.summary          = 'Calendar designed to select a date or period.'

  s.homepage         = 'https://github.com/4egoshev/CalendarScrollView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Aleksandr Chegoshev' => '4egoshev@gmail.com' }
  s.source           = { :git => 'https://github.com/4egoshev/CalendarScrollView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.swift_version = "4.2"

  s.source_files = 'CalendarScrollView/Classes/**/*'
end
