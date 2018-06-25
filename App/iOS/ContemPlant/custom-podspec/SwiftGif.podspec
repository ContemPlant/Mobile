Pod::Spec.new do |s|
  s.name         = 'SwiftGif'
  s.version      = '1.6.2' # my customized version...
  s.authors       = { 'Arne Bahlo' => 'hallo@arne.me' }
  s.homepage     = 'https://github.com/swiftgif/SwiftGif'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.summary      = "A small UIImage extension with gif support."

  s.source       = { :git => 'https://github.com/swiftgif/SwiftGif.git', :branch => 'master' }

  s.requires_arc = true

  #s.default_subspecs = [] # no subspecs

  #define the source files
  s.source_files = 'SwiftGifCommon/*.swift'

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.1'
  s.watchos.deployment_target = '3.0'

end
