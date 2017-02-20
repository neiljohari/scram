require "spec_helper"

module Scram
  describe Scram::Holder do

    it "cannot be used without an implementation" do
      expect {UnimplementedHolder.new.policies}.to raise_error(NotImplementedError)
      expect {UnimplementedHolder.new.scram_compare_value}.to raise_error(NotImplementedError)
    end

    it "holds model permissions" do
      target = Target.new
      target.actions << "woot"

      policy = Policy.new
      policy.collection_name = TestModel.name # A misc policy for strings
      policy.targets << target
      dude = SimpleHolder.new(policies: [policy]) # This is a test holder, his scram_compare_value by default is "Mr. Holder Guy"

      # Check that it tests a field equals something
      target.conditions = {:equals => { :targetable_int =>  3}}
      policy.save
      expect(dude.can? :woot, TestModel.new).to be true

      # Check that it tests a field is less than something
      target.conditions = {:less_than => { :targetable_int =>  4}}
      policy.save
      expect(dude.can? :woot, TestModel.new).to be true

      # Test that it checks if an array includes something
      target.conditions = {:includes => {:targetable_array => "a"}}
      policy.save
      expect(dude.can? :woot, TestModel.new).to be true

      # Test that it checks if a document is owned by holder
      target.conditions = {:equals => {:owner => "*holder"}}
      policy.save
      expect(dude.can? :woot, TestModel.new(owner: "Mr. Holder Guy")).to be true

    end

    it "holds string permissions" do
      target = Target.new
      target.conditions = {:equals => { :'*target_name' =>  "donk"}}
      target.actions << "woot"

      policy = Policy.new
      policy.collection_name = "globals" # A misc policy for strings
      policy.targets << target

      policy.save

      dude = SimpleHolder.new(policies: [policy]) # This is a test holder
      expect(dude.can? :woot, :donk).to be true
    end

    it "differentiates model and string policies" do
      string_policy = Policy.new
      string_policy.collection_name = "non-existent-model"
      string_policy.save

      expect(string_policy.model?).to be false

      model_policy = Policy.new
      model_policy.collection_name = SimpleHolder.name
      model_policy.save

      expect(model_policy.model?).to be true
    end

    # TODO: Investigate whether or not it is worth somehow "force" denying through policies. Consider removing policy-priority system, it is currently useless.
    xit "prioritizes policies" do
      target1 = Target.new
      target1.actions << "woot"
      target1.actions << "zing"
      target1.allow = false

      policy1 = Policy.new
      policy1.collection_name = TestModel.name # A misc policy for strings
      policy1.targets << target1


      target2 = Target.new
      target2.actions << "woot"

      policy2 = Policy.new
      policy2.collection_name = TestModel.name # A misc policy for strings
      policy2.priority = 1
      policy2.targets << target2

      policy1.save
      policy2.save

      user = SimpleHolder.new(policies: [policy1, policy2])
      expect(user.can? :woot, TestModel.new).to be true
      expect(user.can? :donk, TestModel.new).to be false
      expect(user.can? :zing, TestModel.new).to be true
    end

  end
end
