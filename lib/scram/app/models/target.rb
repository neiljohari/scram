module Scram
  class Target
    include Mongoid::Document
    embedded_in :permission_node

    field :conditions, type: Hash, default: {}

    def can? obj
      if obj.is_a? String
        return obj == conditions[:equals][:$target_name]
      else
        # TODO: Comparators
      end
    end
  end
end
