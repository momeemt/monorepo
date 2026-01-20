module Ammonite
  class Color
    attr_accessor :red
    attr_accessor :green
    attr_accessor :blue

    def initialize(red, green, blue)
      @red = red
      @green = green
      @blue = blue
    end

    def new_by_color_code(color_code)
      @red = color_code[1..2].to_i(16)
      @green = color_code[3..4].to_i(16)
      @blue = color_code[5..6].to_i(16)
      self
    end
  end
end
