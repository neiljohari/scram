module Scram
  module AggregateHolder
    include Holder

    def aggregates
      raise NotImplementedError # should be implemented by subclass
    end

    # @return [Array] list of policies
    def policies
      aggregate_policies = aggregates.map {|a| a.policies}.flatten.sort_by {|p| p.priority}.reverse
    end

    # @return [Object] a value to compare {AggregateHolder} in the database. For example, an ObjectID would be suitable.
    def scram_compare_value
      raise NotImplementedError
    end

  end
end
