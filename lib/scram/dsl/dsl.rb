module Scram::DSL
  module DSL
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
