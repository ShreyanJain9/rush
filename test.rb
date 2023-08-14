require_relative "thing.rb"

within "foo" do
  self | ≥ | "bar"
end

within String do
  puts (self.class)
  ƒ :put, -> {
      puts self
    }
end

within "foo" do
  self.put
end

puts (2 | • | 3)
