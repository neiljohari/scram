module Scram
  class Target
    include Mongoid::Document

    embedded_in :permission_node
    field :collection, type: String

    def can? action, target=nil, *args
      return true if self.collection == target.class.name
      return false
    end

  end
end
