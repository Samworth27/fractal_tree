def to_path(x_start, y_start, x_end, y_end, width, colour = 'black')
  "<path d='M #{x_start} #{y_start}, L #{x_end} #{y_end}' stroke = '#{colour}' stroke-width='#{width}' />"
end

def draw_leaf(x_pos, y_pos)
  $file.write "<circle cx='#{x_pos}' cy='#{y_pos}' r='10' fill = 'green' />\n "
end

# Allows implict conversion between angles and radians
class Angle
  include Math
  attr_accessor :degree

  def initialize(angle_degree = 0)
    @degree = angle_degree
  end

  def to_rad
    @degree * (PI / 180)
  end
end

$file = File.open('tree.svg', 'w')
$file.write "<svg viewBox = '0 0 1000 1000' xmlns='http://www.w3.org/2000/svg'>\n"
$file.write "<g transform='rotate(180 500 500)'>\n"
$file.write "<rect width='100%' height='100%' fill='skyblue' />\n"

def split(path_x, path_y, angle, distance, counter)
  puts counter
  if counter != 0
    counter -= 1
    if counter == 0
      draw_leaf(path_x, path_y)
    else
      # Branch 1
      path_x_new = path_x + (Math.sin(angle.to_rad) * rand(distance + counter))
      path_y_new = path_y + (Math.cos(angle.to_rad) * rand(distance + counter))
      $file.write "#{to_path(path_x, path_y, path_x_new, path_y_new, counter)}\n"
      split(path_x_new, path_y_new, Angle.new(angle.degree + rand(-5..30)), distance, counter)
      # Branch 2
      path_x_new = path_x + (Math.sin(angle.to_rad) * rand(distance + counter))
      path_y_new = path_y + (Math.cos(angle.to_rad) * rand(distance + counter))
      $file.write "#{to_path(path_x, path_y, path_x_new, path_y_new, counter)}\n"
      split(path_x_new, path_y_new, Angle.new(angle.degree - rand(-5..30)), distance, counter)
    end
  end
end

split(500, 0, Angle.new, 70, 10)
$file.write "</g>\n </svg>"
$file.close
