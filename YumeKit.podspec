Pod::Spec.new do |s|
    s.name     = 'YumeKit'
    s.version  = '4.2.0'
    s.license  = 'MIT'
    s.summary  = "A Library for Yume use"
    s.homepage = 'https://github.com/yume190/YumeKit'
    s.authors  = { 'yume190' => 'yume190@gmail.com' }
    s.social_media_url = "https://www.facebook.com/yume190"
    s.source   = { :git => 'https://github.com/yume190/YumeKit.git', :tag => s.version }
  
    s.ios.deployment_target = '9.0'
    # s.osx.deployment_target = '10.11'
  
    # s.tvos.deployment_target = '9.0'
    # s.watchos.deployment_target = '2.0'
    s.default_subspec = "Core"
    s.swift_version = '4.2'
    s.static_framework = true
  
    s.subspec "Core" do |ss|
      ss.source_files = [
        "YumeKit/Codable/*.swift",
        "YumeKit/CoreData/*.swift",
        "YumeKit/Extension/*.swift",
        "YumeKit/FP/*.swift",
        "YumeKit/Kit/*.swift",
        "YumeKit/Listable/*.swift",
        "YumeKit/Macro/*.swift",
        "YumeKit/NotificationCenter/*.swift",
        "YumeKit/Regex/*.swift",
        "YumeKit/State/*.swift",
        "YumeKit/Time/*.swift",
        "YumeKit/View/*.swift"
      ]
      #   #"Sources/Moya/", "Sources/Moya/Plugins/"
      # s.dependency "Alamofire", "~> 4.4.0"
      # s.dependency "JSONDecodeKit", "~> 4.1.0"
      # s.dependency 'AwaitKit', '~> 5.0.1'
      # # s.dependency 'PromiseKit', '~> 6.5.2'
      ss.framework  = "Foundation"
    end
  
    # s.subspec "JSONMock" do |ss|
    #   ss.source_files = "Sources/JSONMock/*.swift"
    #   ss.dependency "YumeAlamofire/Core"
    # end
  end
  