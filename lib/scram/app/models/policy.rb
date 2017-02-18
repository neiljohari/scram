module Scram
  class Policy
    include Mongoid::Document
    store_in collection: 'scram_policies'
    
    embeds_many :targets

    validates_presence_of :collection

    field :collection, type: String # This is usually a model name, but depending on `model` it could also just be a global policy
    field :model, type: Boolean, default: true # Is this a Policy affiliated with a model (i.e. is `collection` a Model)?
    field :permission_nodes, type: Array, default: []
    def can? action, target
      if target.is_a? String
        return false if self.model # target is a string, this policy handles models
        return false unless target == collection # This policy does not support that string target

      else # model instance, hopefully
        return false unless self.model # target is a model, this policy handles strings
        return false unless target.name == self.collection # Prevent unnecessarily checking nodes and targets if this policy doesn't support the model

      end
    end
  end
end
