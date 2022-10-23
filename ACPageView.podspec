
Pod::Spec.new do |spec|

  spec.name         = "ACPageView"
  spec.version      = "0.0.2"
  spec.summary      = "Swift ACPageView"

 
  spec.description  = "TestPro. is used to appstore check. more click https://github.com/ActionsLjx/ACPageView.git"

  spec.homepage     = "https://github.com/ActionsLjx/ACPageView.git"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  spec.license      = "MIT"
  # spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  spec.author             = { "actionsljx" => "actionsljx@foxmail.com" }
  # Or just: spec.author    = "actionsljx"
  # spec.authors            = { "actionsljx" => "actionsljx@foxmail.com" }
  # spec.social_media_url   = "https://twitter.com/actionsljx"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  spec.platform     = :ios
  spec.platform     = :ios, "11.0"

  #  When using multiple platforms
  # spec.ios.deployment_target = "5.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"

  spec.source       = { :git => "https://github.com/ActionsLjx/ACPageView.git", :tag => "#{spec.version}" }

  spec.source_files  = "Sources/*.{swift,xib}"
 # spec.exclude_files = "Classes/Exclude"

  # spec.public_header_files = "Classes/**/*.h"

  # spec.resource  = "icon.png"
  # spec.resources = "Resources/*.png"
  spec.swift_version = '5.0'


end
