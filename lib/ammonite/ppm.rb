# encoding: UTF-8

module Ammonite
  class PPM

    attr_accessor :binary

    def initialize
      self
    end

    def size(x, y)
      @binary = Array.new(x).map {
        Array.new(y).map {
          Array.new(3, 255)
        }
      }
      @pixel_x = x
      @pixel_y = y
      self
    end

    def image(path)
      File.open(path, "rt") do |file|
        binary_type = file.gets
        size = file.gets.split(' ')
        color_max = file.gets
        @pixel_x = size[0]
        @pixel_y = size[1]
        binary = file.gets
        @binary = Array.new(@pixel_x).map {
          Array.new(@pixel_y).map {
            Array.new(3, 255)
          }
        }
        (0...@pixel_y).each do |y|
          (0...@pixel_x).each do |x|
            @binary[y][x][0] = binary[@pixel_x * y + 3 * x].ord
            @binary[y][x][1] = binary[@pixel_x * y + 3 * x + 1].ord
            @binary[y][x][2] = binary[@pixel_x * y + 3 * x + 2].ord
          end
        end
      end
      self
    end

    def fill_all(color)
      (0...@pixel_y).each { |y|
        (0...@pixel_x).each { |x|
          @binary[y][x][0] = color.red
          @binary[y][x][1] = color.green
          @binary[y][x][2] = color.blue
        }
      }
      self
    end

    def fill(color, start_pos, end_pos)
      (start_pos.y...end_pos.y).each do |y|
        (start_pos.x...end_pos.x).each do |x|
          @binary[y][x][0] = color.red
          @binary[y][x][1] = color.green
          @binary[y][x][2] = color.blue
        end
      end
      self
    end

    def stroke(start_pos, end_pos)
      dx = end_pos.x - start_pos.x
      dy = end_pos.y - start_pos.y
      x = start_pos.x
      y = start_pos.y
      delta_x_mid = dy / 2
      delta_x = delta_x_mid
      while y != end_pos.y
        if x >= @pixel_x or y >= @pixel_y
          continue
        end
        @binary[y][x][0] = @binary[y][x][1] = @binary[y][x][2] = 255
        y += 1
        delta_x += dx
        if delta_x >= dy
          delta_x -= dy
          x += 1
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
            file.write @binary[y][x][0].chr(Encoding::UTF_8)
            file.write @binary[y][x][1].chr(Encoding::UTF_8)
            file.write @binary[y][x][2].chr(Encoding::UTF_8)
          }
        }
      end
    end
  end
end