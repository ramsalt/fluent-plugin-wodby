lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name    = "fluent-plugin-wodby"
  spec.version = "0.1.3"
  spec.authors = ["Robert Wunderer"]
  spec.email   = ["robert@ramsalt.com"]

  spec.summary       = %q{Tranlates Wodbys instance UUIDs into instance names}
  spec.homepage      = "https://github.com/ramsalt/fluent-plugin-wodby"
  spec.license       = "Apache-2.0"

  test_files, files  = `git ls-files -z`.split("\x0").partition do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.files         = files
  spec.executables   = files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = test_files
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.3.7"
  spec.add_development_dependency "rake", "~> 13.0.6"
  spec.add_development_dependency "test-unit", "~> 3.5.3"
  spec.add_runtime_dependency "fluentd", [">= 0.14.10", "< 2"]
  spec.add_runtime_dependency "rest-client", "~> 2.0"
  spec.add_runtime_dependency "json", "~> 2.0"
end
