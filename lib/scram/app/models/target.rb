module Scram
  class Target
    include Mongoid::Document

    embedded_in :permission_node

    field :collection, type: String
    field :match_states, type: Hash, default: {}

    validates_presence_of :collection

    def can? action, target, *args
      return false if action.to_s != permission_node.name.to_s # This node doesn't apply at all

      if match_states.empty? # This target is a broad collection based ability
        return true if self.collection == target.class.name
      else
        model = self.collection.constantize
        return model.where(match_states).include? target # Figure out if any model this target applies to includes the parameter target
      end
    end

  end
end
