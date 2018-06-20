Pod::Spec.new do |s|
  s.name         = 'Apollo'
  s.version      = '0.9.0' # my customized version...
  s.author       = 'Meteor Development Group'
  s.homepage     = 'https://github.com/apollographql/apollo-ios'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.summary      = "A GraphQL client for iOS, written in Swift."

  s.source       = { :git => 'https://github.com/apollographql/apollo-ios.git', :branch => 'master' }

  s.requires_arc = true

  s.default_subspecs = ['Core', 'SQLite', 'WebSocket'] # added to install all the other default subspecs

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.1'
  s.watchos.deployment_target = '3.0'

  s.subspec 'Core' do |ss|
    ss.source_files = 'Sources/Apollo/*.swift'
    ss.resource = 'scripts/check-and-run-apollo-codegen.sh'
  end

  # Apollo provides exactly one persistent cache out-of-the-box, as a reasonable default choice for
  # those who require cache persistence. Third-party caches may use different storage mechanisms.
  s.subspec 'SQLite' do |ss|
    ss.source_files = 'Sources/ApolloSQLite/*.swift'
    ss.dependency 'Apollo/Core'
    ss.dependency 'SQLite.swift', '~> 0.11.4'
  end

  # Websocket and subscription support based on Starscream
  s.subspec 'WebSocket' do |ss|
    ss.source_files = 'Sources/ApolloWebSocket/*.swift'
    ss.dependency 'Apollo/Core'
    ss.dependency 'Starscream', '~> 3.0.2'
  end

end
