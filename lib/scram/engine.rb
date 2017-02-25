require "rails/mongoid"
require "mongoid"

module Scram
  class Engine < ::Rails::Engine
    isolate_namespace Scram

    config.generators do |g|
      g.test_framework :rspec, :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end
  end
end
