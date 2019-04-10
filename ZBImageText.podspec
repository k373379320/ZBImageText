
Pod::Spec.new do |s|
    s.name = 'ZBImageText'
    s.version = '0.1.2'
    s.summary = 'A delightful iOS Uitilty framework.'
    s.homepage = 'https://github.com/k373379320/ZBImageText'
    s.license = { :type => 'MIT', :file => 'LICENSE' }
    s.author = { '373379320@qq.com' => '373379320@qq.com' }
    s.source = { :git => 'https://github.com/k373379320/ZBImageText.git', :tag => s.version.to_s }
    s.ios.deployment_target = '8.0'
    s.source_files = 'ZBImageText/Classes/**/*.{h,m}'
    s.ios.dependency 'YYText'
    s.ios.dependency 'SDWebImage'
    s.frameworks = 'ImageIO'
end
