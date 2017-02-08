module Cannable

  module ClassMethods
    private attr_writer :pass_to
    public attr_reader :pass_to

    def cannable plurality=:single, pass_to:
      self.pass_to = pass_to
      delegate :can? => pass_to
      module_to_mix = case plurality
        when :single then Single
        when :collection then Collection
      end
      define_cannable module_to_mix
    end
  end

  def pass_to
    self.class.pass_to
  end

  def define_cannable(module_to_mix)
    alias_method pass_to, "#{pass_to}_without_cannable"
    define_method pass_to do |*args|
     send("#{pass_to}_without_cannable", args).tap{prepend module_to_mix}
    end
  end


  module Single
    def can?(*args)
      if pass_to
        send(pass_to, *args)
      else
        super()
    end
  end

  module Collection
    def can? action, target=nil, *args
      all? {|n| n.can? action, target, *args }
    end
  end
end
