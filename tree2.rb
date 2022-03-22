# A 2d vector for path points
# (distance, direction)
class PathPoint
  attr_accessor :x_pos, :y_pos, :distance, :direction

  def initialize(distance, direction = Angle.new(0), x_pos = 500, y_pos = 500)
    @x_pos = x_pos
    @y_pos = y_pos
    @distance = distance
    @direction = direction
  end
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

def to_path(x_start, y_start, x_end, y_end, width, colour = 'black')
  "<path d='M #{x_start} #{y_start}, L #{x_end} #{y_end}' stroke = '#{colour}' stroke-width='#{width}' />"
end

def draw_leaf(x_pos, y_pos)
  $file.write "<circle cx='#{x_pos}' cy='#{y_pos}' r='10' fill = 'green' />\n "
end

def draw_branch(path)
  string = "<path d='M #{path[0].x_pos} #{path[0].y_pos}, "
  path.each_with_index do |point, index|
    string += "L #{point.x_pos} #{point.y_pos}, "
  end
  string += "' fill = 'none' stroke = 'black' />"
  $file.write string
end

$file = File.open('tree.svg', 'w')
$file.write "<svg viewBox = '0 0 1000 1000' xmlns='http://www.w3.org/2000/svg'>\n"
$file.write "<g transform='rotate(180 500 500)'>\n"
$file.write "<rect width='100%' height='100%' fill='skyblue' />\n"

# Recursive function to draw trees. counter = 'number of iterations to be completed'
def split(counter, path = [])
  # puts counter
  if counter != 0
    counter -= 1
    if counter.zero?
      draw_leaf(path[-1].x_pos, path[-1].y_pos)
      draw_branch(path)
    else
      node = path[-1]
      # p node

      # Branch 1
      new_distance = rand(node.distance + counter)
      new_x = node.x_pos + (Math.sin(node.direction.to_rad) * new_distance)
      new_y = node.y_pos + (Math.cos(node.direction.to_rad) * new_distance)
      # Set angle
      new_angle = node.direction.degree + rand(30)

      next_point = PathPoint.new(new_distance, Angle.new(new_angle), new_x, new_y)
      split(counter, path.clone.append(next_point))
      # Branch 2
      new_distance = rand(node.distance + counter)
      new_x = node.x_pos + (Math.sin(node.direction.to_rad) * new_distance)
      new_y = node.y_pos + (Math.cos(node.direction.to_rad) * new_distance)
      # Set angle
      new_angle = node.direction.degree - rand(30)

      next_point = PathPoint.new(new_distance, Angle.new(new_angle), new_x, new_y)
      split(counter, path.clone.drop(1).append(next_point))
    end
  end
end

split(10, [PathPoint.new(100)])
$file.write "</g>\n </svg>"
$file.close
