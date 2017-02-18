module Scram
  class PermissionNode
    include Mongoid::Document

    embedded_in :policy
    embeds_many :targets

    field :name, type: String

    def can? action, target
      return false unless action == self.name # prevent checking targets if the action isn't relevant
      return targets.any? {|target| target.can? target}
    end
  end
end
