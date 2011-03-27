require 'rubygems'
require 'rspec'
require 'cukeregator'
Dir["spec/cukeregator/support/**/*.rb"].each { |lib| require lib }

RSpec.configure do |config|
  config.include(Spec::Functional::Cli)
end

