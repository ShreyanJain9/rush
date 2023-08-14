ƒ :•, ->() {
    ° ->(a, b) { a ** b }
  }

ƒ :∑, ->(*a) {
    ¿ a.length == 1, -> {
        ¿ ([Cons, Array].include?(a[0].class)), -> {
            a[0].inject(:+)
          }, -> {
            a.inject(:+)
          }
      }, -> {
        a.inject :+
      }
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
