Pod::Spec.new do |s|
  s.name                  = "EasyIOS"
  s.version               = "1.0.2"
  s.summary               = "EasyIOS is a frameWork base on MKNetworkKit and MJRefresh"
  s.homepage              = "https://github.com/zhuchaowe"
  s.social_media_url      = "https://swift.08dream.com"
  s.platform     = :ios,'6.0'
  s.license               = { :type => "MIT", :file => "LICENSE" }
  s.author                = { "zhuchao" => "zhuchaowe@163.com" }
  s.source                = { :git => "https://github.com/zhuchaowe/EasyIOS.git"}
  s.ios.deployment_target = "6.0"
  s.requires_arc          = true
  s.framework             = "CoreFoundation","Foundation","CoreGraphics","Security","UIKit"
  s.library		= "z.1.1.3","stdc++","sqlite3"
  s.subspec 'Easy' do |sp|
    sp.source_files = '*.{h,m,mm}','Easy/**/*.{h,m,mm}','Extend/**/*.{h,m,mm}'
    sp.requires_arc = true
    sp.resources   = "Extend/**/*.{png,json,ttf,otf}"
    sp.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libz, $(SDKROOT)/usr/include/libxml2', 'CLANG_CXX_LANGUAGE_STANDARD' => 'gnu++0x', 'CLANG_CXX_LIBRARY' => 'libstdc++', 'CLANG_WARN_DIRECT_OBJC_ISA_USAGE' => 'YES'}
    sp.prefix_header_contents = '#import "swift-bridge.h"'
  end
end
