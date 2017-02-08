require "spec_helper"
require "bouncer/holder" # Test implementation of Holder

module Bouncer
  describe Holder do
    it "holds permissions" do
      node = PermissionNode.new
      node.name = "woot.donk"
      node.targets << Target.new()
      node.allowed = true

      policy = Policy.new
      policy.permission_nodes << node

      policy.save

      dude = ::Holder.new(policies: [policy]) # This is a test holder
      expect(dude.can? "woot.donk").to be true
    end
  end
end
