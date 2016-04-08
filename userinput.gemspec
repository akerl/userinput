Gem::Specification.new do |s|
  s.name        = 'userinput'
  s.version     = '1.0.2'
  s.date        = Time.now.strftime("%Y-%m-%d")

  s.summary     = 'Simple user input library'
  s.description = 'Provides a prompt object for requesting user input'
  s.authors     = ['Les Aker']
  s.email       = 'me@lesaker.org'
  s.homepage    = 'https://github.com/akerl/userinput'
  s.license     = 'MIT'

  s.files       = `git ls-files`.split
  s.test_files  = `git ls-files spec/*`.split

  s.add_development_dependency 'rubocop', '~> 0.39.0'
  s.add_development_dependency 'rake', '~> 11.1.0'
  s.add_development_dependency 'codecov', '~> 0.1.1'
  s.add_development_dependency 'rspec', '~> 3.4.0'
  s.add_development_dependency 'fuubar', '~> 2.0.0'
end
