require "spec_helper"

describe Scram::Target do
  # A test model that we apply our targets to
  class Model
    include Mongoid::Document
    field :targetable_int, type: Integer, default: 3
  end

  let(:target) { FactoryGirl.build(:target) }

  it "targets a collection" do
  end


  it "targets document states" do
  end

end
