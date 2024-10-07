# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = 'fixturizer'
  spec.version       = `cat VERSION`.chomp
  spec.authors       = ['Pierre ALPHONSE', 'Romain GEORGES']
  spec.email         = ['pierre.alphonse@orange.com', 'romain@ultragreen.net']

  spec.summary       = 'Ruby fixturizer tools for applications testing'
  spec.description   = 'Ruby fixturizer tools for applications testing'
  spec.homepage      = 'https://github.com/Ultragreen/fixturizer'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 3.2.3')

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.add_dependency 'mongoid', '~> 9.0'
  spec.add_dependency 'rake', '~> 13.0'
  spec.add_dependency 'rspec', '~> 3.13.0'
  spec.add_dependency 'version', '~> 1.1'

  spec.add_development_dependency 'bundle-audit', '~> 0.1.0'
  spec.add_development_dependency 'code_statistics', '~> 0.2.13'
  spec.add_development_dependency 'cyclonedx-ruby', '~> 1.1'
  spec.add_development_dependency 'debride', '~> 1.12'
  spec.add_development_dependency 'diff-lcs', '~> 1.5.1'
  spec.add_development_dependency 'rubocop', '~> 1.32'
  spec.add_development_dependency 'yard', '~> 0.9.27'
  spec.add_development_dependency 'yard-rspec', '~> 0.1'
end
