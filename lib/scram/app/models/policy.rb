module Scram
  class Policy
    include Mongoid::Document
    store_in collection: 'scram_policies'
    embeds_many :permission_nodes
    embeds_many :targets

    validates_presence_of :collection

    field :collection, type: String # This is usually a model name, but depending on `model` it could also just be a global policy
    field :model, type: Boolean # Is this a Policy affiliated with a model (i.e. is `collection` a Model)?
  end
end
