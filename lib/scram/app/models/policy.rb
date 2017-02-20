module Scram
  # Model to represent a Holder's permission policy
  class Policy
    include Mongoid::Document
    store_in collection: 'scram_policies'

    embeds_many :targets

    validates_presence_of :collection

    # @return [Integer] Priority to allow this policy to override another conflicting {Scram::Policy} opinion.
    field :priority, type: Integer, default: 0

    # @return [String] What this Policy applies to. Usually it will be the name of a Model, but it can also be a String for a "global" policy for non model-bound permissions
    field :collection_name, type: String

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
        return Module.const_get(collection_name)
      rescue NameError
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
      target = target.to_s if target.is_a? Symbol
      action = action.to_s

      # The following checks prevent unnecessary iteration
      if obj.is_a? String # ex: can? :view, "peek_bar"
        return :abstain if self.model? # policy doesn't handle strings
      else                # ex: can? :edit, @model_instance
        return :abstain if !self.model? # policy doesn't handle models
        return :abstain if self.collection_name != obj.class.name # policy doesn't handle these types of models
      end

      targets.order_by([[:priority, :desc]]).each do |target|
        opinion = target.can?(holder, action, obj)
        return opinion if %i[allow deny].include? opinion
      end

      return :abstain
    end
  end
end
