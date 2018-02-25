module Scram
  using SymbolExtensions

  # Base class to represent a Holder of permissions through policies.
  # @note Implementing classes must implement #policies and #scram_compare_value
  module Holder
    extend ActiveSupport::Concern

    # @return [Array] list of policies
    def policies
      raise NotImplementedError
    end

    # @return [Object] a value to compare {Holder} in the database. For example, an ObjectID would be suitable.
    def scram_compare_value
      raise NotImplementedError
    end

    # Checks if this holder can perform some action on an object by checking the Holder's policies
    # @param action [String] What the user is trying to do to obj
    # @param obj [Object] The receiver of the action
    # @return [Boolean] Whether or not holder can action to object. We define a full abstainment as a failure to perform the action.
    def can? action, target
      target = target.to_s if target.is_a? Symbol
      action = action.to_s

      # Checks policies in priority order for explicit allow or deny.
      policies.sort_by(&:priority).reverse.each do |policy|
        opinion = policy.can?(self, action, target)
        return opinion.to_bool if %i[allow deny].include? opinion
      end

      return false
    end

    # Helper method to enhance readability of permission checks
    def cannot? *args
      !can?(*args)
    end

  end
end
