require "spec_helper"

describe Scram::Target do
  class Model
    include Mongoid::Document
    field :targetable_int, type: Integer, default: 3
  end

  let(:target) {FactoryGirl.build(:target)}

  it "targets a collection" do
    target.collection = "Model"
    target.permission_node.name = :anything # This can be anything we want, since we're specifying that this target applies to the entire collection
    target.permission_node.save # save parent to trigger save embeds

    obj = Model.new
    expect(target.can? :blorgh, obj).to eq(true)
  end


  xit "targets document states" do

  end

end
