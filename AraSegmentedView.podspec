
Pod::Spec.new do |s|
  s.name             = 'AraSegmentedView'
  s.version          = '0.0.1'
  s.summary          = 'Elegant segmented view in Swift. Inspired by Bilibili.'

  s.homepage         = 'https://github.com/Arabaku/AraSegmentedView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Arabaku@126.com' => 'Arabaku@126.com' }
  s.source           = { :git => 'https://github.com/Arabaku/AraSegmentedView.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'
  s.source_files = 'Source/**/*.swift'
  s.requires_arc = true
end
