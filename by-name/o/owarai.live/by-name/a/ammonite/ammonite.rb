# encoding: UTF-8

require 'nokogiri'
require 'rmagick'

include Magick

$current_processing_image = nil
$current_processing_image_path = ""

def print_node(node)
  if node.name == "img"
    unless node.attributes["src"].nil?
      image_path = node.attribute("src").to_s
      $current_processing_image = Magick::ImageList.new(image_path)
      $current_processing_image_path = image_path
    end
  elsif node.name == "blur"
    radius = node.attribute("radius").to_s.to_f
    sigma = node.attribute("sigma").to_s.to_f
    blur_processed_image = $current_processing_image.blur_image(radius, sigma)
    blur_processed_image.write($current_processing_image_path)
  elsif node.name == "text"
    if node.text?
      image = Magick::ImageList.new($current_processing_image_path)
      draw = Magick::Draw.new
      text = node.text.to_s
      x = node.attribute("x").to_s.to_i
      y = node.attribute("y").to_s.to_i
      draw.annotate(image, 0, 0, x, y, text) do
        self.fill = 'black'
        self.pointsize = 50
        self.gravity = Magick::SouthEastGravity
      end
      image.write($current_processing_image_path)
    end
  end
end

def dfs(node_with_flag)
  if node_with_flag[1]
    return
  end
  node_with_flag[1] = true
  print_node(node_with_flag[0])
  children = node_with_flag[0].children
  children_with_flag = children.map{|child|
    [child, false]
  }
  children_with_flag.each{|child_with_flag|
    unless child_with_flag[1]
      dfs(child_with_flag)
    end
  }
end

amm = ""
File.open('gray-scale.amm') do |file|
  amm = Nokogiri::HTML(file)
end

body = amm.at_css('body')

body_with_flag = [body, false]
dfs(body_with_flag)

# body.traverse do |node|
#   print_node(node)
# end

# load 'lib/ammonite.rb'
#
# pmm = Ammonite::PPM.new
# color = Ammonite::Color.new(50, 100, 150)
# pos1 = Ammonite::Position.new(50, 100)
# pos2 = Ammonite::Position.new(150, 200)
# pos3 = Ammonite::Position.new(100, 0)
# pos4 = Ammonite::Position.new(0, 500)
#
# # pmm.image("/Users/momiyama/Library-Develop/ammonite/sample1.ppm").save("sample")
#
# pmm
#     .size(500, 500)
#     .fill_all(color)
#     .stroke(pos1, pos2, 8)
#     .stroke(pos3, pos4, 8)
#     .save("sample4")