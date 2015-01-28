# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.authors = ['Hans Krutzer', 'Flurin Egger']
  s.email = ['info@digitpaint.nl', 'hans@digitpaint.nl', 'flurin@digitpaint.nl']
  s.name = 'roger_jshint'
  s.version = '0.0.2'
  s.homepage = 'https://github.com/hkrutzer/roger_scsslinter'

  s.summary = 'Lint JavaScript files within Roger'
  s.description = <<-EOF
    Lint JavaScript files from within Roger, using jshint.
    Will use .jshintrc.
  EOF
  s.licenses = ['MIT']

  s.date = Time.now.strftime('%Y-%m-%d')

  s.files = `git ls-files`.split("\n")
  s.require_paths = ['lib']

  s.add_dependency 'roger', '~> 0.13', '>= 0.13.0'

  s.add_development_dependency 'rubocop', ['>= 0']
  s.add_development_dependency 'rake', ['>= 0']
  s.add_development_dependency 'test-unit', ['>= 0']
end
