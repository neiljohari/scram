require "spec_helper"
module Scram

  require 'active_support/core_ext/module'
  class TopLevelFoo
    attr_accessor :midlevelfoos

    def initialize
      @midlevelfoos = [MidLevelFoo.new, MidLevelFoo.new]
    end

    include Cannable
    cannable pass_to: :@midlevelfoos # Midlevel foos is a collection
  end

  class MidLevelFoo
    attr_accessor :final_foo # Final foo is a single

    def initialize
      @final_foo = FinalFoo.new
    end

    include Cannable
    cannable pass_to: :@final_foo
  end

  class FinalFoo
    # Anyone can wonk donk, but no one can do anything else
    def can? action, target, *args
      return true if action == :wonk && target == :donk
      false
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
        expect(top_level_foo.can? :wonk, :bonk).to eq(false)
      end
    end


  end
end
