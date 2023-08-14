class StructDefiner
  def initialize
    @props = {}
  end

  def construct(&block)
    instance_eval(&block)
    classgen(reset)
  end

  def method_missing(attr_name, *args, &block)
    if args.length > 0 && args[0].is_a?(Class)
      attr_type = args[0]
      @props.merge!({ attr_name => attr_type })
    end
    self
  end

  def reset
    w = @props
    @props = {}
    w
  end

  def classgen(hash)
    Class.new do
      @@keys = []
      hash.each do |k, v|
        define_method("#{k}=") do |val|
          if val.is_a?(v)
            instance_variable_set("@#{k}", val)
          else
            raise TypeError, "#{val} is not a #{v}"
          end
        end
        attr_reader k
        @@keys << k
      end

      define_method(:initialize) do |**params|
        params.each do |attr, val|
          expected_type = hash[attr.to_sym]
          if val.is_a?(expected_type)
            instance_variable_set("@#{attr}", val)
          else
            raise TypeError, "#{attr} must be a #{expected_type}"
          end
        end
      end

      def self.keys
        @@keys
      end
    end
  end
end

$structdef = StructDefiner.new

module Kernel
  def struct(class_name = nil, &block)
    new_class = $structdef.construct(&block)
    if class_name
      Object.const_set(class_name.to_s, new_class)
    else
      new_class
    end
  end
end

struct(:Company) {
  name String
  address String
}

struct(:Person) {
  name String
  age Integer
}

struct(:Job) {
  title String
  company Company
}

struct(:Employee) {
  person Person
  job(-> { Job }.call)
  salary Integer
}
