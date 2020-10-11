module Ammonite
  class Position
    attr_accessor :x
    attr_accessor :y

    def initialize(x, y)
      @x = x
      @y = y
    end

    def +(other)
      Position.new(self.x + other.x, self.y + other.y)
    end

    def -(other)
      Position.new(self.x - other.x, self.y - other.y)
    end
  end
end
