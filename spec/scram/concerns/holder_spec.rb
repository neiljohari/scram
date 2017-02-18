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
    it "holds permissions" do

      target = Target.new
      target.conditions = {:equals => { :@target_name =>  "donk"}}

      node = PermissionNode.new
      node.name = "woot"
      node.targets << target

      policy = Policy.new
      policy.collection_name = "globals" # A misc policy for strings
      policy.model = false # again, it's for strings
      policy.permission_nodes << node

      policy.save

      dude = SimpleHolder.new(policies: [policy]) # This is a test holder
      expect(dude.can? :woot, :donk).to be true
    end
  end
end
