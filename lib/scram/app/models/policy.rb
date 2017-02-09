module Scram
  class Policy
    include Mongoid::Document
    store_in collection: 'scram_policies'

    include Cannable
    cannable pass_to: :permission_nodes

    embeds_many :permission_nodes
  end
end
