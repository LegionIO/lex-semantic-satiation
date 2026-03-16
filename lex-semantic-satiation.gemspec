# frozen_string_literal: true

require_relative 'lib/legion/extensions/semantic_satiation/version'

Gem::Specification.new do |spec|
  spec.name          = 'lex-semantic-satiation'
  spec.version       = Legion::Extensions::SemanticSatiation::VERSION
  spec.authors       = ['Esity']
  spec.email         = ['matthewdiverson@gmail.com']

  spec.summary       = 'LEX Semantic Satiation'
  spec.description   = 'Semantic satiation and habituation modeling for brain-modeled agentic AI'
  spec.homepage      = 'https://github.com/LegionIO/lex-semantic-satiation'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.4'

  spec.metadata['homepage_uri']        = spec.homepage
  spec.metadata['source_code_uri']     = 'https://github.com/LegionIO/lex-semantic-satiation'
  spec.metadata['documentation_uri']   = 'https://github.com/LegionIO/lex-semantic-satiation'
  spec.metadata['changelog_uri']       = 'https://github.com/LegionIO/lex-semantic-satiation'
  spec.metadata['bug_tracker_uri']     = 'https://github.com/LegionIO/lex-semantic-satiation/issues'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir.glob('{lib,spec}/**/*') + %w[lex-semantic-satiation.gemspec Gemfile LICENSE README.md]
  end
  spec.require_paths = ['lib']
  spec.add_development_dependency 'legion-gaia'
end
