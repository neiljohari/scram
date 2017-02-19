module Scram::DSL
  module Definitions
    def self.add_comparators(builder)
      COMPARATORS.merge!(builder.comparators)
    end

    COMPARATORS = Builders::ComparatorBuilder.new do
      comparator :equal do |a, b|
        a==b
      end

      comparator :greater_than do |a, b|
        a>b
      end

      comparator :less_than do |a, b|
        a<b
      end

      comparator :includes do |a, b|
        a.send(:includes?, b)
      end

      comparator :not_equal do |a, b|
        a != b
      end
    end.comparators
  end
end
