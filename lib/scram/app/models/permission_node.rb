module Scram
  class PermissionNode
    include Mongoid::Document
    embedded_in :policy

    field :name, type: String
  end
end
