Pod::Spec.new do |s|
  s.name             = 'SwiftMockTemplates'
  s.version          = '0.2.2'
  s.summary          = 'Code-generation templates for Swift language.'
  s.description      = <<-DESC
Code-generation templates (to be used along with Sourcery engine) for generating advanced protocol mock classes
that can be used as test doubles in place of object dependencies for unit-testing.
                       DESC
  s.homepage         = 'https://github.com/ivanmisuno/swift-sourcery-templates'
  s.license          = { :type => 'Apache License, Version 2.0' }
  s.author           = { 'Ivan Misuno' => 'i.misuno@gmail.com' }

  s.dependency 'Sourcery', '2.1.2'

  s.source           = { :http => "https://github.com/ivanmisuno/swift-sourcery-templates/releases/download/#{s.version}/swift-sourcery-templates-#{s.version}.zip" }
  s.preserve_paths   = '*'
  s.exclude_files    = '**/*.zip'

end
