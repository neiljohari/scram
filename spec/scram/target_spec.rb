require "spec_helper"

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
end
