require "spec_helper"

describe Scram::Target do
  # A test model that we apply our targets to
  class Model
    include Mongoid::Document
    field :targetable_int, type: Integer, default: 3
  end

  let(:target) { FactoryGirl.build(:target) }

  it "targets a collection" do
    # Allow node to "blorgh" any "Model"
    target.collection = "Model"
    target.permission_node.name = :blorgh
    target.permission_node.save # save parent to trigger save embeds

    obj = Model.new
    expect(target.permission_node.can? :blorgh, obj).to eq(true)
    expect(target.permission_node.can? :dargh, obj).to eq(false)
  end


  it "targets document states" do
    # Allow node to "blorgh" any "Model" where targetable_int = 5
    target.collection = "Model"
    target.match_states = {targetable_int: 5}
    target.permission_node.name = :blorgh
    target.permission_node.save # save parent to trigger save embeds

    obj = Model.create(targetable_int: 2)
    expect(target.can? :blorgh, obj).to eq(false) # We cannot blorgh a Model with targetable_int = 2!

    obj1 = Model.create(targetable_int: 5)
    expect(target.can? :blorgh, obj1).to eq(true) # We can blorgh a Model with targetable_int = 5 though
  end

end
