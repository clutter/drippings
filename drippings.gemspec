require_relative "lib/drippings/version"

Gem::Specification.new do |spec|
  spec.name        = "drippings"
  spec.version     = Drippings::VERSION
  spec.authors     = ["Benjamin Hogoboom"]
  spec.email       = ["benjamin.hogoboom@clutter.com"]
  spec.homepage    = "https://github.com/clutter/drippings"
  spec.summary     = "Tool for automating drip campaigns"
  spec.description = "Rails extension for scheduling drip campaigns"
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails"
  spec.add_development_dependency "factory_bot_rails"
  spec.add_development_dependency "rspec_junit_formatter"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-rails"
  spec.add_development_dependency "rubocop-rspec"
end
