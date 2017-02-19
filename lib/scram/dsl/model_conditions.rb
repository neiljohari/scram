module Scram::DSL
  # Module for Models to include to be able to define special condition variables in their targets
  module ModelConditions
    def self.included(base_class)
      base_class.extend ClassMethods
    end

    module ClassMethods
      # @return [Hash] Mapping of condition names to Procs to execute them
      attr_accessor :scram_conditions

      # Method meant to be used in the including class to begin defining conditions
      #
      # Example
      #   scram_define do
      #     condition :foo do
      #       |instance| "hello world"
      #     end
      #   end
      def scram_define(&block)
        @scram_conditions = Builders::ConditionBuilder.new(&block).conditions
      end
    end

  end
end
