require 'rubygems'
require 'rspec'
require 'cuknitter'
Dir["spec/cuknitter/support/**/*.rb"].each { |lib| require lib }

RSpec.configure do |config|
  config.include(Spec::Functional::Cli)
end

