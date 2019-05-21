# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dont_repeat_for/version'

Gem::Specification.new do |spec|
  spec.name          = "dont_repeat_for"
  spec.version       = DontRepeatFor::VERSION
  spec.authors       = ["Jay El-Kaake"]
  spec.email         = ["najibkaake@gmail.com"]

  spec.summary       = %q{Allows you to easily run a code block only once every X amount of time}
  spec.description   = %q{Allows you to easily run a code block only once every X amount of time}
  spec.homepage      = "https://www.github.com/jayelkaake/dont_repeat_for"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rails", ">= 4.0.0"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "temping", "~> 3.3.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", '~> 3.4'
  spec.add_development_dependency "sqlite3", '~> 1.3.11'

end
