class Holder
    include Bouncer::Holder

    attr_accessor :policies

    def initialize(policies: [])
        @policies = policies
    end
end
