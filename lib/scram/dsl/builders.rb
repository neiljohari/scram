module Scram::DSL
  # DSL Builders
  module Builders
    # Base class for DSL Builder
    # Executes initializer block within context of builder
    class Builder
        def initialize(&block)
          instance_exec(&block)
        end
    end

    # TODO: Flatten comparatorbuilder and conditionbuilder into one "DictionaryBuilder"
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
