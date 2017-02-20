require "scram/concerns/aggregate_holder"

module Scram
  class SimpleAggregateHolder
    include AggregateHolder

    attr_accessor :aggregates

    def initialize(aggregates: [])
        @aggregates = aggregates
    end

    def scram_compare_value
      "Mr. Aggregate Holder Guy"
    end
  end
end
