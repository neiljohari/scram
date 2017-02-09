class Holder
    include Scram::Holder

    attr_accessor :policies

    def initialize(policies: [])
        @policies = policies
    end
end
