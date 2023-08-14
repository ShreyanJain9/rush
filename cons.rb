class NilClass
  ƒ :empty?, -> {
      true
    }
  ƒ :size, -> {
      0
    }
  ƒ :to_a, -> {
      []
    }
end

module Kernel
  ƒ :cons, ->(car, cdr) { Cons.new(car, cdr) }
  ƒ :car, ->(x) { x.car }
  ƒ :cdr, ->(x) { x.cdr }
  ƒ :null?, ->(x) { x.nil? || x.empty? }
end

ƒ :list, ->(*elements) {
    elements.reverse_each.reduce(nil) { |cdr, car| cons(car, cdr) }
  }

ƒ :´, ->(*elements) {
    list(*elements)
  }

ƒ :map, ->(list, func) {
    ¿ (null?(list)), -> { nil },
      -> { cons(func.call(car(list)), map(cdr(list), func)) }
  }

ƒ :filter, ->(list, func) {
    ¿ (null?(list)), -> { nil },
      -> { ¿ func.call(car(list)), -> { cons(car(list), filter(cdr(list), func)) }, -> { filter(cdr(list), func) } }
  }

class Array
  ƒ :to_l, -> {
      ´(*self)
    }
end

class Enumerator
  ƒ :to_l, -> {
      ´ *self
    }
end

class Cons
  class << self
    ƒ :enum_redef, ->(*syms) {
        syms.each do |sym|
          ƒ sym, ->(&block) {
              ´(*super(&block))
            }
        end
      }
  end
  include Enumerable
  ƒ :initialize, ->(car, cdr) {
      @car = car
      @cdr = cdr
    }
  ƒ :to_s, -> {
      "(#{car} . #{cdr})"
    }
  ƒ :inspect, -> {
      "(#{car.inspect} #{cdr.inspect})"
    }
  ƒ :empty?, -> {
      (cdr.nil? || cdr.empty?) && car.nil?
    }
  ƒ :size, -> {
      1 + cdr.size
    }
  ƒ :to_a, -> {
      [car] + cdr.to_a
    }

  ƒ :+, ->(o) {
      cons(car + car(o), cdr + cdr(o))
    }

  ƒ :[], ->(n) {
      ¿ (n == 0), -> { car }, -> { cdr[n - 1] }
    }

  ƒ :car, ->(arg = nil) {
      ¿ arg.nil?, -> { @car }, -> { arg.car }
    }
  ƒ :cdr, ->(arg = nil) {
      ¿ arg.nil?, -> { @cdr }, -> { arg.cdr }
    }

  ƒ :each, ->(&block) {
      current = self
      while !current.nil?
        block.call(car(current))
        current = cdr(current)
      end
    }
  enum_redef :map, :reduce, :filter, :sort, :grep, :reject, :collect
end

class NilClass
  ƒ :to_ary, -> {
      []
    }
end

module Quote
  class Quoter
    def initialize
      @symbols = []
    end

    def Quote!(&block)
      instance_eval(&block)
      Nullify!
    end

    def method_missing(symbol_name, *args, &block)
      ¿ (args.length > 0 && args[0].class == Symbol), -> { @symbols << args[0] }
      @symbols << symbol_name.to_sym
      self
    end

    def Nullify!
      ret = @symbols
      @symbols = []
      ret.reverse.to_l
    end
  end

  Q = Quoter.new
end

module Kernel
  ƒ :quote, ->(&block) {
      Quote::Q.Quote!(&block)
    }
  ƒ :˚, ->(&block) {
      quote(&block)
    }
end
