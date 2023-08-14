within String do
  ƒ :titlecase, ->() {
      self.split(" ")
        .map(&:capitalize)
        .join(" ")
    }
end
