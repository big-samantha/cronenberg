require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'io/console'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc 'Start a pry console with Cronenberg loaded'
task :console do
    exec "pry -r cronenberg -I ./lib"
end

desc 'Start a pry console with Cronenberg loaded and dummy configuration'
task :console_dummy_envvars do
  ENV['VCENTER_SERVER']='pizzacenter.pizza.com'
  ENV['VCENTER_USER']='pizzacenter'
  ENV['VCENTER_PASSWORD']='pizzapass'
  Rake::Task[:console].execute
end


desc 'Start a pry console with Cronenberg loaded and accept configuration arguments'
task :console_set_envvars, [:server,:user] do |task, args|
  ENV['VCENTER_SERVER'] = args[:server]
  ENV['VCENTER_USER']= args[:user]

  print 'Password> '
  password =  STDIN.noecho(&:gets).chomp
  puts "\nPassword set for duration of sesssion."
  ENV['VCENTER_PASSWORD']= password

  Rake::Task[:console].execute
end
