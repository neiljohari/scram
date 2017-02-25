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
  end
end
