module Scram
  # A broad Target interface to scope in a {Scram::Policy}
  class Target
    include Mongoid::Document
    embedded_in :policy

    # @return [Array] Actions which this target applies to
    field :actions, type: Array, default: []

    # @return [Hash] Conditions which this target filters through. Keys are comparators, values are hashes of fields and values to compare.
    field :conditions, type: Hash, default: {}

    # @return [Integer] Priority to allow this target to override another conflicting {Scram::Target} opinion.
    field :priority, type: Integer, default: 0

    # @return [Boolean] This target's modification onto a permission (allow or deny)
    field :allow, type: Boolean, default: true

    # Checks if a {Scram::Holder} can perform some action on an object given this target's conditions and allow-stance.
    #
    # Scram allows for special names:
    #   To make this target applicable to a string, use a key `@target_name` with value of the string permission.
    #   To compare a value to a holder, use `@holder` for a value. To compare a value to a custom condition defined by {Scram::DSL::Builders::ConditionBuilder}
    #   use an @-symbol before a key name (this name should match the one defined in your model).
    # @param holder [Scram::Holder] The actor
    # @param action [String] What the user is trying to do to obj
    # @param obj [Object] The receiver of the action
    # @return [Boolean] Whether or not holder can action to object
    def can? holder, action, obj
      target = target.to_s if target.is_a? Symbol
      action = action.to_s if action.is_a? Symbol

      return false unless actions.include? action
      return false if !allow
      if obj.is_a? String # Handle String permissions with a simple check on the equals field
        return obj == conditions[:equals][:'*target_name']
      else # Attempt to prove false by finding a condition or attribute where comparisons fail
        conditions.each do |comparator_name, fields_hash|
          comparator = Scram::DSL::Definitions::COMPARATORS[comparator_name]
          fields_hash.each do |field, model_value|
            attribute = begin obj.send(field.to_s) rescue return false end
            model_value.gsub! "*holder", holder.scram_compare_value if model_value.respond_to?(:gsub!)
            return false unless comparator.call(attribute, model_value)
          end
        end
      end
      return true
    end
  end
end
