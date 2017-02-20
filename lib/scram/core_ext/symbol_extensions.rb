# Refinements to the Symbol class
module SymbolExtensions
  refine Symbol do
    # Converts self to a boolean if it is :allow, :abstain, :deny. Assumes that abstain means false.
    # @return [Boolean] Boolean representation of allow, abstain, or deny. Abstain means false.
    # @raise [NotImplementedError] If unsupported symbol is converted (not :allow, :abstain, :deny)
    def to_bool
      raise NotImplementedError("Cannot convert #{self} to a boolean! #to_bool only supports :allow, :abstain and :deny.") unless %i[allow abstain deny].include? self
      return true if self == :allow
      return false if self == :abstain
      return false if self == :deny
    end
  end
end
