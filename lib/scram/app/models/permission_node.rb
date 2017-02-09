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
      return true if self.name == action && target != nil # Return early if we're just doing a name-based check
      return targets.can? action, target=nil, *args
    end
  end
end
