module Scram::DSL
  # Default definitions from builders
  module Definitions
    # Adds a custom comparator using a builder
    def self.add_comparators(builder)
      COMPARATORS.merge!(builder.comparators)
    end

    # Default comparators
    # note: yes, this is a bit silly, but it allows for custom comparators easily
    ## really this is just a mapping between name and method (since ==, >=, etc are all just methods as well)
    COMPARATORS = Builders::ComparatorBuilder.new do
      comparator :equals do |a, b|
        a==b
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
