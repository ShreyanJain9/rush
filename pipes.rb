## Shell-style pipes live here
## For writing to a file, we have |≥| for append and |≥≥| for overwrite
## This reverses the Bash conventions. To use the old conventions, use > and >> with strings.

ƒ :≥≥, ->() {
    ° ->(str, file) { File.open(file, "w") { |f| f.write(str) } }
  }

ƒ :≥, ->() {
    ° ->(str, file) { File.open(file, "a") { |f| f.write(str) } }
  }

within String do
  ƒ :>>, ->(filename) {
      File.open(filename, "a") { |f| f.write self }
    }

  ƒ :>, ->(filename) { # come on nobody needs to compare strings anyway
      File.open(filename, "w") { |f| f.write self }
    }
end

# example: "hello!" |≥| "world.txt" appends "hello!" to "world.txt"

# This works *somewhat* like the Elixir pipe operator. It's not quite the same, but it's close enough.
ƒ :», -> {
    ° ->(obj, method) {
        send method, obj
      }
  }
