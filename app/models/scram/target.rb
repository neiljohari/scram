module Scram
  # A broad Target interface to scope in a {Scram::Policy}. A target must either whitelist or deny through its allow attribute.
  class Target
    include Mongoid::Document
    embedded_in :policy, class_name: "Scram::Policy"

    # @return [Array] Actions which this target applies to
    field :actions, type: Array, default: []

    # @return [Hash] Conditions which this target filters through. Keys are comparators, values are hashes of fields and values to compare.
    field :conditions, type: Hash, default: {}

    # @return [Integer] Priority to allow this target to override another conflicting {Scram::Target} opinion.
    field :priority, type: Integer, default: 0

    # @return [Boolean] This target's modification onto a permission (allow or deny), i.e. its type
    field :allow, type: Boolean, default: true

    # Ensures that hash follows the right format
    validate :conditions_hash_validations

    # @return [Symbol] The type of this target (either permissive as allow or deny)
    def target_type
      allow ? :allow : :deny
    end

    # Checks if a {Scram::Holder} can perform some action on an object given this target's conditions and allow-stance.
    #
    # Scram allows for special names:
    #   To make this target applicable to a string, use a key `*target_name` with value of the string permission.
    #   To compare a value to a holder, use `*holder` for a value. To compare a value to a custom condition defined by {Scram::DSL::Builders::ConditionBuilder}
    #   use an * before a key name (this name should match the one defined in your model).
    # @param holder [Scram::Holder] The actor
    # @param action [String] What the user is trying to do to obj
    # @param obj [Object] The receiver of the action
    # @return [Symbol] This target's opinion on an action and object. :allow and :deny mean this target explicitly defines
    #   its opinion, while :abstain means that this Target is not applicable to the action, and so has no opinion.
    def can? holder, action, obj
      obj = obj.to_s if obj.is_a? Symbol
      action = action.to_s

      return :abstain unless actions.include? action

      # Handle String permissions
      if obj.is_a? String
        if obj == conditions[:equals][:'*target_name']
          return target_type
        else
          return :abstain
        end
      end

      # Model permissions
      # Attempts to abstain by finding a condition or attribute where comparisons fail (and thus this target would be unapplicable)
      conditions.each do |comparator_name, fields_hash|
        comparator = Scram::DSL::Definitions::COMPARATORS[comparator_name.to_sym]
        fields_hash.each do |field, model_value|
          # Either gets the model's attribute or gets the DSL defined condition.
          # Abstains if neither can be reached
          attribute = begin obj.send(:"#{field}") rescue return :abstain end

          # Special value substitutions
          (model_value = holder.scram_compare_value) if model_value.to_s == "*holder"
          # Abstain if this target doesn't apply to obj in any of its attributes
          return :abstain unless comparator.call(attribute, model_value)
        end
      end

      return target_type
    end

    private

    # Validates that the conditions Hash follows an expected format
    def conditions_hash_validations
      conditions.each do |comparator, mappings|
        errors.add(:conditions, "can't use undefined comparators") unless Scram::DSL::Definitions::COMPARATORS.keys.include? comparator.to_sym
        errors.add(:conditions, "comparators must have values of type Hash") unless mappings.is_a? Hash
      end
    end
  end
end
