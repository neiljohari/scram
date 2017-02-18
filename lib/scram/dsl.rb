module Scram
  module DSL
    def self.included(base_class)
      base_class.extend ClassMethods
    end

    module ClassMethods
      attr_accessor :scram_conditions

      def scram_define(&block)
        @scram_conditions = ConditionBuilder.new(&block).conditions
      end
    end

    class ConditionBuilder
      attr_accessor :conditions

      def initialize(&block)
        @conditions = {}
        instance_exec(&block)
      end

      def condition variable, &block
        @conditions[variable] = block
      end
    end
  end
end
