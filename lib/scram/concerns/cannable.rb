# Cannable make can? checks forward down a chain
# It is a "smarter" delegate method, accounting for if we are passing to a collection
## CAVEAT: To intercept initialize, Cannable must be included below the initialize definition
module Cannable
  extend ActiveSupport::Concern

  module ClassMethods
    private
      attr_writer :pass_to
    public
      attr_reader :pass_to

    def cannable pass_to:
      self.pass_to = pass_to
    end
  end

  def self.included(base) # Intercepts initialize
    base.class_eval do
      #original_method = instance_method(:initialize)

      alias_method :initialize_old, :initialize

      define_method(:initialize) do |*args, &block|
        #original_method.bind(self).call(*args, &block)
        self.send(:initialize_old, *args, &block)

        pass_to = instance_variable_get(self.class.pass_to)

        # If pass_to isn't a single object, we forward our check to each element
        if pass_to.is_a? Enumerable
          pass_to.send(:define_singleton_method, :can?) do |*args|
            return pass_to.any? { |element| element.send(:can?, *args) }
          end
        end

        self.class.delegate :can?, to: self.class.pass_to
      end
    end
  end

end
