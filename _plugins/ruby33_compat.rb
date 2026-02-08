# Ruby 3.2+ removed taint checking. Liquid 4.0.3 still calls #tainted? on
# objects (including String and nil). Provide a compatibility shim for Ruby 3.2+.
if !String.method_defined?(:tainted?)
  class String
    def tainted?
      false
    end

    def taint
      self
    end

    def untaint
      self
    end
  end

  class NilClass
    def tainted?
      false
    end
  end

  class Object
    def tainted?
      false
    end

    def taint
      self
    end

    def untaint
      self
    end
  end
end
