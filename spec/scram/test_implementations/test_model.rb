module Scram
  class TestModel
    include Mongoid::Document
    include Scram::DSL::ModelConditions

    field :targetable_int, type: Integer, default: 3
    field :targetable_array, type: Array, default: ["a"]
    field :owner, type: String
  end
end
