require "spec_helper"

module Scram
  describe Scram::Policy do
    it "prioritizes targets" do
      policy = Policy.new
      policy.context = TestModel.name # A misc policy for strings

      # Create a target that doesn't let us woot
      target1 = Target.new
      target1.actions << "woot"
      target1.allow = false

      # Create an even more important target that lets us woot
      target2 = Target.new
      target2.actions << "woot"
      target2.allow = true
      target2.priority = 1

      policy.targets << target1
      policy.targets << target2

      policy.save

      expect(policy.can? nil, :woot, TestModel.new).to be :allow
    end
  end
end
