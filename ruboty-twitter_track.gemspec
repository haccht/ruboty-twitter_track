# coding: utf-8
$LOAD_PATH << File.expand_path('../lib', __FILE__)
require 'ruboty/twitter_track/version'

Gem::Specification.new do |spec|
  spec.name          = 'ruboty-twitter_track'
  spec.version       = Ruboty::TwitterTrack::VERSION
  spec.authors       = ['haccht']
  spec.email         = ['haccht@users.noreply.github.com']
  spec.summary       = "Ruboty handler to track tweets in the twitter stream."
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/haccht/ruboty-twitter_track'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'ruboty'
  spec.add_runtime_dependency 'tweetstream'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
end
