require "spec_helper"

module Scram
  class SimpleDSLImplementation
    include DSL

    attr_accessor :owner

    scram_define do
      condition :owner do |instance|
        instance.owner
      end
    end
  end

  describe Scram::DSL do
    it "defines and retrieves conditions" do
      test = SimpleDSLImplementation.new
      test.owner = "bob"

      owner_retrieval_condition = SimpleDSLImplementation.scram_conditions[:owner]
      expect(owner_retrieval_condition.call(test)).to eq("bob")
    end
  end
end
