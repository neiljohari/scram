require "rails_helper"

module Scram
  describe Scram::AggregateHolder do

    it "cannot be used without an implementation" do
      expect {UnimplementedAggregateHolder.new.policies}.to raise_error(NotImplementedError)
      expect {UnimplementedAggregateHolder.new.aggregates}.to raise_error(NotImplementedError)
      expect {UnimplementedAggregateHolder.new.scram_compare_value}.to raise_error(NotImplementedError)
    end

    it "uses permissions from aggregates" do
      target1 = Target.new
      target1.actions << "woot"
      policy1 = Policy.new
      policy1.context = TestModel.name # A misc policy for strings
      policy1.targets << target1
      holder1 = SimpleHolder.new(policies: [policy1])

      target2 = Target.new
      target2.actions << "donk"
      policy2 = Policy.new
      policy2.context = TestModel.name # A misc policy for strings
      policy2.targets << target2
      holder2 = SimpleHolder.new(policies: [policy2])

      user = SimpleAggregateHolder.new(aggregates: [holder1, holder2])
      expect(user.can? :woot, TestModel.new).to be true
      expect(user.can? :donk, TestModel.new).to be true
      expect(user.can? :zing, TestModel.new).to be false
    end

    it "uses the aggregate holder compare value for ownership checking" do
      target = Target.new
      target.actions << "woot"
      target.conditions = {:equals => {:owner => "*holder"}}

      policy = Policy.new
      policy.context = TestModel.name # A misc policy for strings
      policy.targets << target
      holder = SimpleHolder.new(policies: [policy])

      user = SimpleAggregateHolder.new(aggregates: [holder])
      expect(user.can? :woot, TestModel.new(owner: "Mr. Aggregate Holder Guy")).to be true
      expect(user.can? :woot, TestModel.new(owner: "Mr. Holder Guy")).to be false

      another_user = SimpleAggregateHolder.new(aggregates: [])
      class << another_user
        def scram_compare_value
          "Mr. Aggregate Holder Guy Jr."
        end
      end

      expect(another_user.can? :woot, TestModel.new(owner: "Mr. Aggregate Holder Guy")).to be false

    end
  end
end
