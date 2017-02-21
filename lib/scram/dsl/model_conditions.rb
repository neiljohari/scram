module Scram::DSL
  # Module for Models to include to be able to define special condition variables in their targets
  # @note Changes behavior of method_missing! Calling a method prefixed with * will search for scram conditions to invoke
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

    # Methods starting with an asterisk are tested for DSL defined conditions
    def method_missing(method, *args)
      if method.to_s.starts_with? "*"
        condition_name = method.to_s.split("*")[1].to_sym
        conditions = self.class.scram_conditions
        if conditions && !conditions[condition_name].nil?
          return conditions[condition_name].call(self)
        end
      end
      super
    end

    # Allow DSL condition methods to show up as methods (i.e fix #respond_to?)
    def respond_to_missing?(method, include_private = false)
      if method.to_s.starts_with? "*"
        condition_name = method.to_s.split("*")[1].to_sym
        conditions = self.class.scram_conditions
        if conditions && !conditions[condition_name].nil?
          return true
        end
      end
      super
    end
  end
end
