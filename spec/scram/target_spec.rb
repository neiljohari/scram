require "rails_helper"

module Scram
  describe Scram::Target do
    it "returns false when a field doesn't apply" do
      policy = Policy.new
      policy.context = TestModel.name

      target = Target.new
      target.actions << "woot"
      target.allow = true
      target.conditions = {:equals => {:'*non_existant_condition' => 3, :non_existant_field => 3}}
      policy.targets << target

      policy.save

      dude = SimpleHolder.new(policies: [policy]) # This is a test holder
      expect(dude.can? :woot, TestModel.new).to be false
    end

    it "can compare holders" do
      policy = Policy.new
      policy.context = SimpleHolder.name

      target = Target.new
      target.actions << "edit"
      target.allow = true
      target.conditions = {:equals => {:scram_compare_value => :'*holder'}}
      policy.targets << target

      policy.save

      dude1 = SimpleHolder.new(policies: [policy], scram_compare_value: "Mr. Holder Guy")
      dude2 = SimpleHolder.new(policies: [], scram_compare_value: "Mr. Holder Man")

      expect(dude1.can? :edit, dude1).to be true
      expect(dude1.can? :edit, dude2).to be false
      expect(dude2.can? :edit, dude2).to be false
      expect(dude2.can? :edit, dude1).to be false
    end
  end

  describe Scram::Target do
    it "allows model-wide permissions" do
      policy = Policy.new
      policy.context = TestModel.name

      target = Target.new
      target.actions << "woot"
      target.allow = true
      target.conditions = {} # Allow the actions on _anything_, including a passed in class
      policy.targets << target

      policy.save

      dude = SimpleHolder.new(policies: [policy])
      expect(dude.can? :woot, TestModel).to be true
      expect(dude.can? :woot, TestModel.new).to be true # you can check based off an instance as well
    end

    it "validates that the conditions use defined comparators" do
      target = Target.new
      target.conditions = {undefined_comparator: {}}

      target.valid?
      target.errors[:conditions].should include("can't use undefined comparators")
    end

    it "validates that the conditions only map to Hashes" do
      target = Target.new
      target.conditions = {equals: []}

      target.valid?
      target.errors[:conditions].should include("comparators must have values of type Hash")
    end
  end
end
