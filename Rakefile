require 'rake/testtask'
require 'rubocop/rake_task'

task :default => [:test, :rubocop]

desc 'Run rubocop'
task :rubocop do
  RuboCop::RakeTask.new
end

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end
