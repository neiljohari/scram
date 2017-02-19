require "spec_helper"

module Scram
  class SimpleDSLImplementation
    include Scram::DSL::ModelConditions

    attr_accessor :owner

    scram_define do
      condition :owner do |instance|
        instance.owner
      end
    end
  end

  describe Scram::DSL::ModelConditions do
    it "defines and retrieves conditions" do
      test = SimpleDSLImplementation.new
      test.owner = "bob"

      owner_retrieval_condition = SimpleDSLImplementation.scram_conditions[:owner]
      expect(owner_retrieval_condition.call(test)).to eq("bob")
    end
  end

  describe Scram::DSL::Definitions do
    it "defines and retrieves default comparators" do
      equal_comparator = Scram::DSL::Definitions::COMPARATORS[:equal]
      expect(equal_comparator.call("a", "a")).to be true
      expect(equal_comparator.call("a", "b")).to be false
    end

    it "can define new comparators" do
      builder = Scram::DSL::Builders::ComparatorBuilder.new do
        comparator :asdf do |a,b|
          true
        end
      end
      Scram::DSL::Definitions.add_comparators(builder)

      asdf_comparator = Scram::DSL::Definitions::COMPARATORS[:asdf]
      expect(asdf_comparator.call("basically", "anything")).to be true
    end
  end
end
