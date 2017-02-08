$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "bouncer"
require 'database_cleaner'
require 'support/factory_girl'

Mongoid.load!('./spec/config/mongoid.yml', :test)

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
