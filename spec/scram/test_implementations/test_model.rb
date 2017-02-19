module Scram
  class TestModel
    include Mongoid::Document

    field :targetable_int, type: Integer, default: 3
    field :targetable_array, type: Array, default: ["a"]
    field :owner, type: String, default: "Mr. Holder Guy"
  end
end
