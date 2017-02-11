require "spec_helper"
require "scram/concerns/holder" # Test implementation of Holder

module Scram
  class SimpleHolder

      attr_accessor :policies

      def initialize(policies: [])
          @policies = policies
      end

      include Holder
  end

  describe Holder do
    it "holds permissions" do
      node = PermissionNode.new
      node.name = "woot.donk"
      #node.allowed = true

      policy = Policy.new
      policy.permission_nodes << node
      policy.save

      dude = SimpleHolder.new(policies: [policy]) # This is a test holder
      expect(dude.can? "woot.donk").to be true
    end
  end
end
