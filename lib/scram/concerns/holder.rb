module Scram
  module Holder
    extend ActiveSupport::Concern

    def policies
      raise NotImplementedError
    end

    def can? action, target
      policies.any? {|p| p.can? action, target}
    end

  end
end
