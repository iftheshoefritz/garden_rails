# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'garden_rails/version'

Gem::Specification.new do |spec|
  spec.name          = 'garden_rails'
  spec.version       = GardenRails::VERSION
  spec.authors       = ['Fritz Meissner']
  spec.email         = ['fritz.meissner@gmail.com']

  spec.summary       = 'Autogenerate YARD directives for your Rails project'
  spec.description   = 'Generate YARD directives for the parts of your Rails' +
                       'project that Ruby tools find difficult to understand' +
                       '(ActiveModel attributes and associations)'
  spec.homepage      = 'https://github.com/iftheshoefritz/garden_rails'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'rspec', '~> 3.2'
end
