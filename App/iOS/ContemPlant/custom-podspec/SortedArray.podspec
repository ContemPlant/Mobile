Pod::Spec.new do |s|
  s.name         = 'SortedArray'
  s.version      = '1.0' # my customized version...
  s.author       = 'ole' # but my pod
  s.homepage     = 'https://github.com/ole/SortedArray'
  s.license      = { :type => 'MIT', :file => 'LICENSE.txt' }

  s.summary      = "An array that keeps its elements sorted according to a given sort predicate."

  s.source       = { :git => 'https://github.com/ole/SortedArray.git', :branch => 'master' }

  s.requires_arc = true

  #s.default_subspecs = [] # no subspecs

  #define the source files
  s.source_files = 'Sources/*.swift'

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.1'
  s.watchos.deployment_target = '3.0'

end
