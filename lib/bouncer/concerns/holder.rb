module Bouncer
  module Holder
    extend ActiveSupport::Concern


    def policies
      raise NotImplementedError
    end

    def can?(action, target=nil, *args)
      policies.each do |policy|
        return true if policy.can?(action, target, args)
      end
      return false
    end

  end
end
