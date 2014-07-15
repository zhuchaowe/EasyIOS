Pod::Spec.new do |s|
  s.name                  = "EasyIOS"
  s.version               = "1.0"
  s.summary               = "EasyIOS is a frameWork base on MKNetworkKit and MJRefresh"
  s.homepage              = "https://github.com/zhuchaowe"
  s.social_media_url      = "https://swift.08dream.com"
  s.license               = { :type => "MIT", :file => "LICENSE" }
  s.author                = { "zhuchao" => "zhuchaowe@163.com" }
  s.source                = { :git => "https://github.com/zhuchaowe/EasyIOS"}
  s.ios.deployment_target = "6.0"
  s.osx.deployment_target = "10.6"
  s.requires_arc          = true
  s.framework             = "CoreFoundation","Foundation","CoreGraphics","Security","UIKit"
  s.library		= "z.1.1.3","stdc++”,”sqlite3”
  s.subspec 'Easy' do |sp|
    sp.source_files = 'EasyIOS/Easy/**/*.{h,m,mm}'
    sp.requires_arc = true
    sp.resources = "EasyIOS/Easy/**/*.{png}"

  end
  s.subspec 'Extend' do |sp|
    sp.source_files = 'EasyIOS/Extend/**/*.{h,m,mm}'
    sp.requires_arc = true
    sp.resources 	 = "EasyIOS/Extend/**/*.{png}"
  end

end
