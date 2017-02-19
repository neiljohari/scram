module Scram::DSL
  module Builders
    class Builder
        def initialize(&block)
          instance_exec(&block)
        end
    end

    class ComparatorBuilder < Builder
      attr_accessor :comparators

      def initialize(&block)
        @comparators = {}
        super(&block)
      end

      def comparator name, &block
        @comparators[name] = block
      end
    end

    class ConditionBuilder < Builder
      attr_accessor :conditions

      def initialize(&block)
        @conditions = {}
        super(&block)
      end

      def condition variable, &block
        @conditions[variable] = block
      end
    end

  end

end
