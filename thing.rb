class Object
  def ƒ(meth_name, lamb)
    define_method(meth_name, &lamb)
  end

  ƒ :ifelse, ->(condition, if_body, else_body = nil) {
      if condition
        if_body.call
      elsif else_body
        else_body.call
      end
    }
end

class Class
  ƒ :attr•, ->(name, &block) {
      ƒ name, ->() {
          ifelse (instance_variable_defined?("@#{name}_var")),
                 -> { instance_variable_get("@#{name}_var") },
                 -> { instance_variable_set("@#{name}_var", block.call) }
        }
    }
end

module Kernel
  def within(obj, lmbda = nil, &block)
    ifelse lmbda,
      ->() { obj.instance_eval(&lmbda) },
      ->() { obj.instance_eval(&block) }
  end

  ƒ :cd, ->(dir) {
      Dir.chdir(dir.to_s)
    }

  ƒ :pwd, ->() {
      Dir.pwd.to_sym
    }
end

class Infix
  def initialize(*a, &b)
    raise "arguments size mismatch" if a.length < 0 || a.length > 3
    raise "both method and block passed" if a.length != 0 && b
    raise "no arguments passed" if a.length == 0 && !b

    @m = a.length > 0 ? (a[0].class == Symbol ? method(a[0]) : a[0]) : b

    if a.length == 3
      @c = a[1]
      @s = a[2]
    end
  end

  ƒ :|, ->(o) {
      ifelse @c,
             ->() { o.class == Infix ? self : @m.(@s, o) },
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

[NilClass, FalseClass, TrueClass, Object, Array].each do |c|
  c.prepend(Module.new do
    ƒ :|, ->(o) {
        ifelse (o.class == Infix),
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

ƒ :≥≥, ->() {
    °(&->(str, file) { File.open(file, "w") { |f| f.write(str) } })
  }

ƒ :≥, ->() {
    °(&->(str, file) { File.open(file, "a") { |f| f.write(str) } })
  }

# example: "hello!" |≥| "world.txt" appends "hello!" to "world.txt"

ƒ :•, ->() {
    ° ->(a, b) { a ** b }
  }

# This infix should work like Elixir's |> operator.
# It should pipe the right operand into the left operand
# and return the result.
ƒ :», ->() {
    ° ->(obj, method) { send method, obj }
  }

within String do
  ƒ :>>, ->(filename) {
      File.open(filename, "a") { |f| f.write(self) }
    }

  ƒ :>, ->(filename) { # come on nobody needs to compare strings anyway
      File.open(filename, "w") { |f| f.write(self) }
    }
end

ƒ :», ->(obj, method) {
    send method, obj
  }

ƒ :∑, ->(*a) {
    a.inject(:+)
  }

ƒ :π, -> {
    Math::PI
  }

ƒ :√, ->(x) {
    Math.sqrt(x)
  }

ƒ :∛, ->(x) {
    Math.cbrt(x)
  }

ƒ :∞, -> {
    Float::INFINITY
  }

ƒ :∝, ->(x) {
    1 / x
  }

ƒ :∂, ->(x) {
    1 / (x * x)
  }

ƒ :∇, ->(x) {
    1 / (x * x * x)
  }

ƒ :∆, ->(x) {
    1 / (x * x * x * x)
  }

ƒ :∆, ->(x) {
    1 / (x * x * x * x)
  }

within String do
  ƒ :titlecase, ->() {
      self.split(" ")
        .map(&:capitalize)
        .join(" ")
    }
end

ifelse (__FILE__ == $0), ->() {
         require "irb"
         require "pp"
         IRB.start
       }
