require "spec_helper"

module Scram
  class TopLevelFoo
    include Cannable
    cannable :collection, pass_to: :midlevelfoos

    attr_accessor :midlevelfoos

    def initialize
      @midlevelfoos = [MidLevelFoo.new, MidLevelFoo.new]
    end
  end

  class MidLevelFoo
    include Cannable
    cannable pass_to: :final_foo

    attr_accessor :final_foo

    def initialize
      @final_foo = FinalFoo.new
    end
  end

  class FinalFoo
    def can? *args
      true
    end
  end

  describe Cannable do
    let(:top_level_foo) {TopLevelFoo.new}

    def test_on_cannables
      %i(TopLevelFoo MidLevelFoo).each do |foo|
          yield(Object.const_get("Scram::#{foo}").new)
      end
    end


    it "is includable" do
      test_on_cannables do |foo|
        expect(foo).to be_a(Cannable)
      end
    end

    it "responds to can?" do
      test_on_cannables do |foo|
        expect(foo).to respond_to(:can?)
      end
    end

    context TopLevelFoo do
      it "chains the can? method down" do
        expect(top_level_foo.can? :wonk, :donk).to eq(true)
      end
    end


  end
end
