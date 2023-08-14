class Object
  def ƒ(meth_name, lamb)
    define_method(meth_name, &lamb)
  end

  ƒ :¿, ->(condition, if_body, else_body = nil) {
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
          ¿ (instance_variable_defined?("@#{name}_var")),
            -> { instance_variable_get("@#{name}_var") },
            -> { instance_variable_set("@#{name}_var", instance_eval(&block)) }
        }
    }
end

module Kernel
  ƒ :within, ->(obj, lmbda = nil, &block) {
      ¿ lmbda,
        ->() { obj.instance_eval(&lmbda) },
        ->() { obj.instance_eval(&block) }
    }

  ƒ :cd, ->(dir) {
      Dir.chdir(dir.to_s)
    }

  ƒ :pwd, ->() {
      Dir.pwd.to_sym
    }

  ƒ :withineach, ->(arr, &block) {
      arr.each { |o|
        within(o, &block)
      }
    }
end
