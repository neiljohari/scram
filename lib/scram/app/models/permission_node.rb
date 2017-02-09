module Scram
  class PermissionNode
    include Mongoid::Document
    include Cannable
    cannable pass_to: :targets

    embedded_in :policy
    embeds_many :targets

    field :name, type: String
    field :allowed, type: Boolean

    def can? action, target=nil, *args
      return false if self.name.to_s != action.to_s # This node doesn't apply at all
      return true if self.name == action && target == nil # Return early if we're just doing a name-based check
      return false if target == nil # If we couldn't check it based off the node name, and we don't even have a target to work with, we cannot do anything.
      return targets.can? action, target, *args
    end

  end
end
