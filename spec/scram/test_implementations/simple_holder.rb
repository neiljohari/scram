require "scram/concerns/holder"

module Scram
  class SimpleHolder
    include Holder

    attr_accessor :policies

    def initialize(policies: [])
        @policies = policies
    end

    def scram_compare_value
      "Mr. Holder Guy"
    end
  end
end