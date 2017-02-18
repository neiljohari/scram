module Scram
  class Policy
    include Mongoid::Document
    store_in collection: 'scram_policies'

    embeds_many :permission_nodes

    validates_presence_of :collection

    field :collection, type: String # This is usually a model name, but depending on `model` it could also just be a global policy
    field :model, type: Boolean, default: true # Is this a Policy affiliated with a model (i.e. is `collection` a Model)?

    def can? action, target
      # The following checks prevent unnecessary iteration

      if target.is_a? String # ex: can? :view, "peek_bar"
        return false if self.model # policy doesn't handle strings
      else                   # ex: can? :edit, @model_instance
        return false if !self.model # policy doesn't handle models
        return false if self.collection != target.name # policy doesn't handle these types of models
      end

      return permission_nodes.any? {|node| node.can? action, target}
    end
  end
end
