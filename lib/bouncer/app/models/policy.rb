module Bouncer
  class Policy
    include Mongoid::Document
    store_in collection: 'bouncer_policies'

    embeds_many :permission_nodes

    def can? action, target=nil, *args
      permission_nodes.each do |node|
        return true if node.can?(action, target, args)
      end
      return false
    end

  end
end
