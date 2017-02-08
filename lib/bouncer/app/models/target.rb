module Bouncer
  class Target
    include Mongoid::Document
    store_in collection: 'bouncer_targets'

    embedded_in :permission_node

    
  end
end
