module Scram
  class Target
    include Mongoid::Document
    #store_in collection: 'scram_targets'

    embedded_in :permission_node


  end
end
