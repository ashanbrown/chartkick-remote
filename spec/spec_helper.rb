require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'active_support'
require 'action_view'
require 'action_controller'
require 'rails/engine'
require 'rspec/rails'
require 'pry'

module Rails
  def self.application
    OpenStruct.new(routes: nil, env_config: {})
  end
end
