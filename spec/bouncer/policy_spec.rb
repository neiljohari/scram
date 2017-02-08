require "spec_helper"

describe Bouncer::Policy do

  context "policy with nodes" do
    let(:policy) { FactoryGirl.create(:policy, permission_nodes_count: 5) }

    it "has permission nodes" do
      expect(policy.permission_nodes.count).to be > 0
    end

  end

end
