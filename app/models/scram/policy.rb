module Scram
  # Model to represent a Holder's permission policy
  class Policy
    include Mongoid::Document

    embeds_many :targets, class_name: "Scram::Target"

    validates_presence_of :name

    # @return [String] Name for this Policy. Purely for organizational purposes.
    field :name, type: String

    # @return [String] What model this Policy applies to. Will be nil if this Policy is not bound to a model.
    field :context, type: String

    # @return [Integer] Priority to allow this policy to override another conflicting {Scram::Policy} opinion.
    field :priority, type: Integer, default: 0

    # Helper method to easily tell if this policy is bound to a model
    # @note Unnecessary since we can just call model.nil?, but it is helpful nonetheless
    # @return [Boolean] True if this Policy is bound to a model, false otherwise
    def model?
      return !model.nil?
    end

    # Attempts to constantize and get a model
    # @return [Object, nil] An object, likely a {::Mongoid::Document}, that this policy is bound to. nil if there is none.
    def model
      begin
        return Module.const_get(context)
      rescue # NameError if context as a constant doesn't exist, TypeError if context nil
        return nil
      end
    end

    # Checks if a {Scram::Holder} can perform some action on an object by checking targets
    # @param holder [Scram::Holder] The actor
    # @param action [String] What the user is trying to do to obj
    # @param obj [Object] The receiver of the action
    # @return [Symbol] This policy's opinion on an action and object. :allow and :deny mean this policy has a target who explicitly defines
    #   its opinion, while :abstain means that none of the targets are applicable to the action, and so has no opinion.
    def can? holder, action, obj
      obj = obj.to_s if obj.is_a? Symbol
      action = action.to_s
      # Abstain if policy doesn't apply to the obj
      if obj.is_a? String # String permissions
        return :abstain if self.model? # abstain if policy doesn't handle strings
      else                # Model permissions
        return :abstain if !self.model? # abstain if policy doesn't handle models

        if obj.is_a?(Class) # Passed in a class, need to check based off the passed in model's name
          return :abstain if self.context != obj.to_s # abstain if policy doesn't handle these types of models
        else # Passed in an instance of a model, need to check based off the instance's class's name
          return :abstain if self.context != obj.class.name
        end
      end

      # Checks targets in priority order for explicit allow or deny.
      targets.order_by([[:priority, :desc]]).each do |target|
        opinion = target.can?(holder, action, obj)
        return opinion if %i[allow deny].include? opinion
      end

      return :abstain
    end
  end
end
