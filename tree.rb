def to_path(x_start, y_start, x_end, y_end, width, colour = 'black')
  "<path d='M #{x_start} #{y_start}, L #{x_end} #{y_end}' stroke = '#{colour}' stroke-width='#{width}' />"
end

def draw_leaf(x_pos, y_pos)
  $file.write "<circle cx='#{x_pos}' cy='#{y_pos}' r='#{rand(10..20)}' opacity = '0.8' stroke ='black' fill = 'green' filter='url(#blur)' />\n "
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

blur = "
<filter id='blur'>\n
    <feGaussianBlur stdDeviation='2'/>\n
</filter>\n
"

$file = File.open('tree.svg', 'w')
$file.write "<svg viewBox = '0 0 1000 1000' xmlns='http://www.w3.org/2000/svg'>\n"
$file.write blur
$file.write "<g transform='rotate(180 500 500)' stroke-linecap='round'>\n"
$file.write "<rect width='100%' height='100%' fill='skyblue' />\n"

def split(path_x, path_y, angle, distance, counter)
  if counter != 0
    counter -= 1
    if counter.zero?
      draw_leaf(path_x, path_y)
    else
      path_x_new = path_x + (Math.sin(angle.to_rad) * rand(distance + counter))
      path_y_new = path_y + (Math.cos(angle.to_rad) * rand(distance + counter))
      # Branch 1

      $file.write "#{to_path(path_x, path_y, path_x_new, path_y_new, counter)}\n"
      split(path_x_new, path_y_new, Angle.new(angle.degree + rand(-10..30)), distance, counter)
      # Branch 2
      path_x_new = path_x + (Math.sin(angle.to_rad) * rand(distance + counter))
      path_y_new = path_y + (Math.cos(angle.to_rad) * rand(distance + counter))
      $file.write "#{to_path(path_x, path_y, path_x_new, path_y_new, counter)}\n"
      split(path_x_new, path_y_new, Angle.new(angle.degree - rand(-10..30)), distance, counter)

    end
  end
end

split(500, 0, Angle.new, 70, 10)
# split(200, 0, Angle.new, 70, 10)
# split(800, 0, Angle.new, 70, 10)
$file.write "</g>\n </svg>"
$file.close
