
Pod::Spec.new do |spec|

  spec.name         = "ACPageView"
  spec.version      = "0.0.3"
  spec.summary      = "Swift ACPageView"
  spec.description  = "ACPageView. is used to appstore check. more click https://github.com/ActionsLjx/ACPageView.git"
  
  spec.homepage     = "https://github.com/ActionsLjx/ACPageView.git"
#s.screenshots      = "https://cloud.githubusercontent.com/assets/5186464/22686432/19b567f8-ed5f-11e6-885d-bd660c98b507.gif"
  spec.license      = "MIT"
  spec.author             = { "actionsljx" => "actionsljx@foxmail.com" }
  spec.source       = { :git => "https://github.com/ActionsLjx/ACPageView.git", :tag => "#{spec.version}" }
  
  spec.platform     = :ios
  spec.ios.deployment_target = '11.0'
  spec.requires_arc = true
  spec.framework    = 'UIKit'
  spec.source_files  = "Sources/*.{swift,xib}"
  spec.swift_version = '5.3'
  spec.cocoapods_version = '>= 1.4.0'

end
