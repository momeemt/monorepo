require 'position'

module Ammonite
  class PPM
    def initialize(x, y)
      @binary = Array.new(x).map {
        Array.new(y).map {
          Array.new(3, 255)
        }
      }
      @pixel_x = x
      @pixel_y = y
      self
    end

    def fill_all(red, green, blue)
      (0...@pixel_y).each { |y|
        (0...@pixel_x).each { |x|
          @binary[y][x][0] = red
          @binary[y][x][1] = green
          @binary[y][x][2] = blue
        }
      }
      self
    end

    def fill(red, green, blue, start_pos, end_pos)
      (start_pos.y...end_pos.y).each do |y|
        (start_pos.x...end_pos.x).each do |x|
          @binary[y][x][0] = red
          @binary[y][x][1] = green
          @binary[y][x][2] = blue
        end
      end
      self
    end

    def save(name)
      File.open("#{name}.ppm", "w") do |file|
        file.write "P6\n"
        file.write "#{@pixel_x} #{@pixel_y}\n"
        file.write "255\n"
        (0...@pixel_y).each { |y|
          (0...@pixel_x).each { |x|
            file.write @binary[y][x][0].chr + @binary[y][x][1].chr + @binary[y][x][2].chr
          }
        }
      end
    end
  end
end