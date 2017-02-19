module Scram
  class Target
    include Mongoid::Document
    embedded_in :policy

    field :actions, type: Array, default: []
    field :conditions, type: Hash, default: {}

    def can? holder, action, obj
      return false unless actions.include? action

      if obj.is_a? String # ex: can? user, :view, "peek_bar"
        return obj == conditions[:equals][:@target_name]
        # ex: conditions: {equals: {@target_name: "peek_bar"}}
      else
        # TODO: Comparators, and dynamic variable checking (and holder comparison)
      end
    end
  end
end
