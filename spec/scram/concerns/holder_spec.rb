require "spec_helper"
require "scram/concerns/holder" # Test implementation of Holder

module Scram
  class SimpleHolder
      include Holder

      attr_accessor :policies

      def initialize(policies: [])
          @policies = policies
      end

  end

  describe Holder do
    xit "holds model permissions" do
    end

    it "holds string permissions" do

      target = Target.new
      target.conditions = {:equals => { :@target_name =>  "donk"}}
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
      string_policy.collection_name = "non-existant-model"
      string_policy.save

      expect(string_policy.model?).to be false

      model_policy = Policy.new
      model_policy.collection_name = SimpleHolder.name
      model_policy.save

      puts "THE MODEL POLICY: #{model_policy.model}"

      expect(model_policy.model?).to be true


    end

  end
end
