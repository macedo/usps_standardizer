require "bundler"
Bundler::GemHelper.install_tasks

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new

require 'rdoc/task'
RDoc::Task.new do |t|
  t.rdoc_dir = "docs"
  t.title    = "USPS Address Standardizer"
  t.options << "-m" << "README.rdoc"
end

