module Cannable
  extend ActiveSupport::Concern

  module ClassMethods
    private
      attr_writer :pass_to, :module_to_mix
    public
      attr_reader :pass_to, :module_to_mix

    def cannable plurality=:single, pass_to:
      self.pass_to = pass_to
      self.module_to_mix = plurality

    end
  end

  def initialize(*args)
    define_cannable
    super
  end

  def define_cannable
    class << self
      if pass_to.is_a? Enumerable
        return pass_to.any? {|element| element.send(:can?, *args)}
      else
        if pass_to
      end
    end
  end

  def pass_to
    self.class.pass_to
  end

  def module_to_mix
    self.class.module_to_mix
  end
end
