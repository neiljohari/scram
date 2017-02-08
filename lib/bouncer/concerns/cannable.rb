module Cannable
  extend ActiveSupport::Concern

  module ClassMethods
    private
      attr_writer :pass_to, :module_to_mix
    public
      attr_reader :pass_to, :module_to_mix

    def cannable plurality=:single, pass_to:
      self.pass_to = pass_to
      delegate :can?, to: pass_to
      self.module_to_mix = plurality
    end
  end

  def initialize(*args)
    define_cannable
    super
  end

  def define_cannable
    class << self # Eigen class (object's special class instance)
      # define pass_to without_permissions
      # preserve the original method
      alias_method "#{pass_to}_without_permissions", pass_to

      permission_check = case plurality
      when :single then Single.can?(self, *args)
      when :collection then send("#{pass_to}_permission_check", *args)
      end

      # define pass_to with permissions
      permission_check ? super : reject

      define_method "#{pass_to}_permission_check" do |*args|
        Collection.can?(*args)
      end

      # Both permissions and execution
      define_method pass_to do |*args|
        if send("#{pass_to}_permission_check")
          send("#{pass_to}_without_permission") # continue with execution
        else
          raise StandardError # TODO Error
        end
      end

    end
  end

  def pass_to
    self.class.pass_to
  end

  def module_to_mix
    self.class.module_to_mix
  end

  module Single
    def self.can?(object, *args)
      if pass_to
        send(pass_to, *args)
      else
        super()
      end
    end
  end

  module Collection
    def self.can?(object, *args)
      all? {|n| n.can? *args }
    end
  end
end
