$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "scram"
require 'database_cleaner'
require 'support/factory_girl'

require 'coveralls'
Coveralls.wear!

require "scram/test_implementations/simple_holder"
require "scram/test_implementations/test_model"

Mongoid.load!('./spec/config/mongoid.yml', :test)
#Mongo::Logger.logger.level = ::Logger::DEBUG

RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

end
