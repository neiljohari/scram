module Scram
  module Holder
    extend ActiveSupport::Concern

    def policies
      raise NotImplementedError
    end

    def can? action, target
      target = target.to_s if target.is_a? Symbol
      action = action.to_s if action.is_a? Symbol

      policies.any? {|p| p.can? self, action, target}
    end

  end
end
