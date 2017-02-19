module Scram
  class Policy
    include Mongoid::Document
    store_in collection: 'scram_policies'

    embeds_many :targets

    validates_presence_of :collection

    field :collection_name, type: String # This is usually a model name, but depending on #model? it could also just be a global policy

    # Helper method to easily tell if this policy is bound to a model
    ## Unnecessary since we can just call model.nil?, but it is helpful nonetheless 
    def model?
      return !model.nil?
    end

    # Attempts to constantize and get a model
    def model
      begin
        return Module.const_get(collection_name)
      rescue NameError
        return nil
      end
    end

    def can? holder, action, obj
      # The following checks prevent unnecessary iteration

      if obj.is_a? String # ex: can? :view, "peek_bar"
        return false if self.model? # policy doesn't handle strings
      else                   # ex: can? :edit, @model_instance
        return false if !self.model? # policy doesn't handle models
        return false if self.collection_name != obj.name # policy doesn't handle these types of models
      end

      return targets.any? {|target| target.can?(holder, action, obj)}
    end
  end
end
