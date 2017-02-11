module Scram
  class Target
    include Mongoid::Document
    embedded_in :policy

    field :conditions, type: Hash, default: {}
  end
end
