module Scram::DSL
  # Module for Models to include to be able to define special condition variables in their targets
  module ModelConditions
    def self.included(base_class)
      base_class.extend ClassMethods
    end

    module ClassMethods
      attr_accessor :scram_conditions

      def scram_define(&block)
        @scram_conditions = Builders::ConditionBuilder.new(&block).conditions
      end
    end

  end
end
