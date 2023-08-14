require_relative "core"
require_relative "infix"
require_relative "struct+"
require_relative "cons"
require_relative "strings/extended"
require_relative "pipes"
require_relative "math/operators"
¿ (__FILE__ == $0), ->() {
    require "irb"
    require "pp"
    IRB.start
  }
