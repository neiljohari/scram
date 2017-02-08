module Bouncer
  module Holder
    extend ActiveSupport::Concern

    def policies
      raise NotImplementedError
    end

  end
end
