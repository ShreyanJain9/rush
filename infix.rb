class Infix
  def initialize(*a, &b)
    raise "arguments size mismatch" if a.length < 0 || a.length > 3
    raise "both method and block passed" if a.length != 0 && b
    raise "no arguments passed" if a.length == 0 && !b

    @m = (¿ (a.length > 0), -> { ¿ (a[0].class == Symbol), -> { method(a[0]) }, -> { a[0] } },
      -> { b })

    ¿ (a.length == 3), -> {
        @c = a[1]
        @s = a[2]
      }
  end

  ƒ :|, ->(o) {
      ¿ @c,
        ->() { ¿ (o.class == Infix), -> { self }, -> { @m.(@s, o) } },
        ->() {
          raise "missing first operand"
        }
    }

  ƒ :coerce, ->(o) {
      [Infix.new(@m, true, o), self]
    }

  ƒ :v, ->(o) {
      Infix.new(@m, true, o)
    }
end

withineach [NilClass, FalseClass, TrueClass, Object, Array] do
  prepend(Module.new do
    ƒ :|, ->(o) {
        ¿ (o.class == Infix),
          -> { o.v(self) },
          -> { super(o) }
      }
  end)
end

module Kernel
  ƒ :Infix, ->(*a, &b) {
      Infix.new(*a, &b)
    }

  ƒ :°, ->(*a, &b) {
      Infix.new(*a, &b)
    }
end
