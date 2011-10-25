Gem::Specification.new do |s|
  s.name = 'cancan_edit'
  s.version = File.read "VERSION"
  s.summary = "cancan ability for views"
  s.authors = "Serkan Gonuler"
  s.email = "serkangonuler@gmail.com"
  s.homepage = 'http://github.com/lisica/cancan_edit' 
  s.files       = Dir["lib/**/*"] << "VERSION" << "readme.markdown" << "cancan_edit.gemspec" 
 
  s.add_development_dependency 'rspec', '~> 2.6.0'
  s.add_dependency  "cancan", '~> 1.6.7'
end
