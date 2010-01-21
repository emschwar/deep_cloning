require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the deep_cloning plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the deep_cloning plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'DeepCloning Plugin'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = 'deep_cloning'
    gem.summary = 'Deep copying for ActiveRecord objects'
    gem.description = 'Deep copying for ActiveRecord objects'
    gem.email = 'eric.schwartz@centro.net'
    gem.homepage = 'http://github.com/emschwar/deep_cloning'
    gem.authors = ['emschwar', 'DefV']
    gem.add_dependency('activerecord')
    gem.add_development_dependency('activerecord', '>=2.3.2')
    gem.add_development_dependency('riot', '>= 0.10.2')
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end
