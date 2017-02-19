module Scram::DSL
  # Default definitions from builders
  module Definitions
    # Adds a custom comparator using a builder
    # @param builder [Scram::Builders::ComparatorBuilder] Builder to merge into the usable comparators
    def self.add_comparators(builder)
      COMPARATORS.merge!(builder.comparators)
    end

    # Default comparators.
    # @note These names are used within the DB as key names for conditions. Pay attention when adding them,
    #   and plan not to be changing them.
    # TODO: Inclusive inequalities
    COMPARATORS = Builders::ComparatorBuilder.new do
      comparator :equals do |a, b|
        a == b
      end

      comparator :greater_than do |a, b|
        a > b
      end

      comparator :less_than do |a, b|
        a < b
      end

      comparator :includes do |a, b|
        a.send(:include?, b)
      end

      comparator :not_equals do |a, b|
        a != b
      end
    end.comparators
  end
end
