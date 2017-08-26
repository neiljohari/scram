require "scram/concerns/holder"

module Scram
  class UnimplementedHolder
    include Holder
  end

  class SimpleHolder
    include Holder

    attr_accessor :policies, :scram_compare_value

    def initialize(policies: [], scram_compare_value: "Mr. Holder Guy")
        @policies = policies
        @scram_compare_value = scram_compare_value
    end
  end
end
