module Scram
  module Holder
    extend ActiveSupport::Concern

    def self.included(base)
      base.include Cannable
      base.cannable pass_to: :policies
    end

    def policies
      raise NotImplementedError
    end

  end
end
