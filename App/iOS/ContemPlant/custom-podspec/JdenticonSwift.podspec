Pod::Spec.new do |s|
  s.name         = 'JdenticonSwift'
  s.version      = '1.0' # my customized version...
  s.author       = 'alejandro-isaza' # but my pod
  s.homepage     = 'https://github.com/alejandro-isaza/jdenticon-swift'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.summary      = "Swift library for generating identicons."

  s.source       = { :git => 'https://github.com/alejandro-isaza/jdenticon-swift.git', :branch => 'master' }

  s.requires_arc = true

  #s.default_subspecs = [] # no subspecs

  #define the source files
  s.source_files = 'Sources/*.swift'

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.1'
  s.watchos.deployment_target = '3.0'

end
