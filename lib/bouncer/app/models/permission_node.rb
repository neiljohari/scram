module Bouncer
  class PermissionNode
    include Mongoid::Document
    store_in collection: 'permission_nodes'

    embedded_in :policy
    embeds_many :targets

    field :name, type: String
    field :allowed, type: Boolean

    def can? action, target=nil, *args
      true
    end
  end
end
