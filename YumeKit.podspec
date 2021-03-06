Pod::Spec.new do |s|
    s.name     = 'YumeKit'
    s.version  = '5.0.4'
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
    s.default_subspec = "ALL"
    s.swift_version = '5.0'
    # s.static_framework = true

    s.subspec "ALL" do |ss|
      ss.dependency "YumeKit/CoreData"
      ss.dependency "YumeKit/FP"
      ss.dependency "YumeKit/Regex"
      ss.dependency "YumeKit/Presentable"
      ss.dependency "YumeKit/Menu"
      ss.dependency "YumeKit/CodableExtension"
      ss.dependency "YumeKit/Notifiable"
      ss.dependency "YumeKit/Core"
    end

    s.subspec "CoreData" do |ss|
      ss.source_files = [
        "YumeKit/CoreData/Kuery/*.swift",
        "YumeKit/CoreData/SuperStack/*.swift"
      ]

      ss.framework  = "CoreData"
      ss.framework  = "Foundation"
    end

    s.subspec "FP" do |ss|
      ss.source_files = [
        "YumeKit/FP/*.swift",
      ]

      ss.framework  = "Foundation"
    end

    s.subspec "Regex" do |ss|
      ss.source_files = [
        "YumeKit/Regex/*.swift",
      ]

      ss.framework  = "Foundation"
    end

    s.subspec "Presentable" do |ss|
      ss.source_files = [
        "YumeKit/Presentable/Box.swift",
        "YumeKit/Presentable/Presentable.swift",
        "YumeKit/Presentable/UIExtension.swift",

        "YumeKit/Presentable/CollectionViewPresentable/*.swift",
        "YumeKit/Presentable/CollectionViewPresentable/SingleSection/*.swift",

        "YumeKit/Presentable/TableViewPresentable/*.swift",
        "YumeKit/Presentable/TableViewPresentable/SingleSection/*.swift",
        "YumeKit/Presentable/TableViewPresentable/MultiSection/*.swift"
      ]

      ss.framework  = "Foundation"
    end

    s.subspec "Menu" do |ss|
      ss.source_files = [
        "Menu/Drawable/*.swift",
        "Menu/Drawable/Factory/*.swift",
        "Menu/Drawable/Factory/Derived/*.swift",

        "Menu/Menu/*.swift",
        "Menu/Menu/Protocol/*.swift",
      ]

      ss.framework  = "Foundation"
    end

    s.subspec "CodableExtension" do |ss|
      ss.source_files = [
        "YumeKit/Codable/*.swift",
      ]

      ss.framework  = "Foundation"
    end

    s.subspec "Notifiable" do |ss|
      ss.source_files = [
        "YumeKit/Notifiable/*.swift"
      ]

      ss.framework  = "Foundation"
    end

    s.subspec "Core" do |ss|
      ss.source_files = [
        "YumeKit/Extension/*.swift",
        "YumeKit/UIExtension/*.swift",
        "YumeKit/Kit/*.swift",
        "YumeKit/Listable/*.swift",
        "YumeKit/Macro/*.swift",
        "YumeKit/State/*.swift",
        "YumeKit/Time/*.swift",
        "YumeKit/View/*.swift",
      ]

      ss.framework  = "UIKit"
    end





    # s.subspec "JSONMock" do |ss|
    #   ss.source_files = "Sources/JSONMock/*.swift"
    #   ss.dependency "YumeAlamofire/Core"
    # end
  end
