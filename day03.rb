# --- Day 3: Gear Ratios ---

# You and the Elf eventually reach a gondola lift station; he says the gondola lift will take you
# up to the water source, but this is as far as he can bring you. You go inside.
#
# It doesn't take long to find the gondolas, but there seems to be a problem: they're not moving.
#
# "Aaah!"
#
# You turn around to see a slightly-greasy Elf with a wrench and a look of surprise. "Sorry, I
# wasn't expecting anyone! The gondola lift isn't working right now; it'll still be a while before
# I can fix it." You offer to help.
#
# The engineer explains that an engine part seems to be missing from the engine, but nobody can
# figure out which one. If you can add up all the part numbers in the engine schematic, it should
# be easy to work out which part is missing.
#
# The engine schematic (your puzzle input) consists of a visual representation of the
# engine. There are lots of numbers and symbols you don't really understand, but apparently any
# number adjacent to a symbol, even diagonally, is a "part number" and should be included in your
# sum. (Periods (.) do not count as a symbol.)
#
# Here is an example engine schematic:
#
# 467..114..
# ...*......
# ..35..633.
# ......#...
# 617*......
# .....+.58.
# ..592.....
# ......755.
# ...$.*....
# .664.598..
#
# In this schematic, two numbers are not part numbers because they are not adjacent to a symbol:
# 114 (top right) and 58 (middle right). Every other number is adjacent to a symbol and so is a
# part number; their sum is 4361.
#
# Of course, the actual engine schematic is much larger. What is the sum of all of the part
# numbers in the engine schematic?
#

# --- Part Two ---

# The engineer finds the missing part and installs it in the engine! As the engine springs to
# life, you jump in the closest gondola, finally ready to ascend to the water source.

# You don't seem to be going very fast, though. Maybe something is still wrong? Fortunately, the
# gondola has a phone labeled "help", so you pick it up and the engineer answers.

# Before you can explain the situation, she suggests that you look out the window. There stands
# the engineer, holding a phone in one hand and waving with the other. You're going so slowly that
# you haven't even left the station. You exit the gondola.

# The missing part wasn't the only issue - one of the gears in the engine is wrong. A gear is any
# * symbol that is adjacent to exactly two part numbers. Its gear ratio is the result of
# multiplying those two numbers together.

# This time, you need to find the gear ratio of every gear and add them all up so that the
# engineer can figure out which gear needs to be replaced.

# Consider the same engine schematic again:

# 467..114..
# ...*......
# ..35..633.
# ......#...
# 617*......
# .....+.58.
# ..592.....
# ......755.
# ...$.*....
# .664.598..

# In this schematic, there are two gears. The first is in the top left; it has part numbers 467
# and 35, so its gear ratio is 16345. The second gear is in the lower right; its gear ratio is
# 451490. (The * adjacent to 617 is not a gear because it is only adjacent to one part number.)
# Adding up all of the gear ratios produces 467835.

# What is the sum of all of the gear ratios in your engine schematic?



require_relative 'input'

day = __FILE__[/\d+/].to_i(10)
input = Input.for_day(day, 2023)

while ARGV[0]
  case ARGV.shift
  when 'test'
    testing = true
  when 'debug'
    debugging = true
  end
end

if testing
  input = <<~END
  467..114..
  ...*......
  ..35..633.
  ......#...
  617*......
  .....+.58.
  ..592.....
  ......755.
  ...$.*....
  .664.598..
  END
  expected = 4361
  expected2 = 467835
else
  puts "solving day #{day} from input"
end

require 'set'
class Schematic
  attr_accessor :grid, :rows, :cols, :symbols

  def initialize
    @grid = []
    @rows = 0
    @cols = nil
    @symbols = Set.new
  end

  def <<(row)
    @cols ||= row.size
    @rows += 1
    @grid << row.tr('.',' ')
    row.tr('.0-9',' ').delete(' ').chars.uniq.each {@symbols << _1}
    self
  end

  def part_numbers
    y = 0
    x = 0
    list = []
    while y < @rows
      while x < @cols
        if @grid[y][x] =~ /[0-9]/
          number = @grid[y][x..-1].to_i
          l = number.to_s.size
          if any_symbol_touches(y, x, l, number)
            # puts `tput clear`
            # puts self.to_s(y: y, x: x)
            # sleep 1
            if block_given?
              yield number
            else
              list << l
            end
          end
          x += l
        else
          x += 1
        end
      end
      y += 1
      x = 0
    end
    if block_given?
      self
    else
      list
    end
  end

  def any_symbol_touches(y, x, l, n)
    [y-1, y, y+1].select{|dy|0<=dy && dy<@rows}.product(((x-1)..(x+l)).to_a.select{|dx|0<=dx && dx<@cols}).
      detect {|dy,dx|
      # puts "trying: #{dy},#{dx} which is #{@grid[dy][dx]}"
      @symbols.include? @grid[dy][dx]
    }
  end

  def symbols_touching(y, x, l, n)
    [y-1, y, y+1].select{|dy|0<=dy && dy<@rows}.product(((x-1)..(x+l)).to_a.select{|dx|0<=dx && dx<@cols}).
      map {|dy,dx|
      [@grid[dy][dx], dy, dx, n] if @symbols.include? @grid[dy][dx]
    }.compact
  end
  def gears
    y = 0
    x = 0
    list = []
    while y < @rows
      while x < @cols
        if @grid[y][x] =~ /[0-9]/
          number = @grid[y][x..-1].to_i
          l = number.to_s.size
          st = symbols_touching(y, x, l, number)
          # puts st.inspect
          if st.any? && st.first.first == '*'
            list << st.first
          end
          x += l
        else
          x += 1
        end
      end
      y += 1
      x = 0
    end
# puts list.inspect
    hash = Hash.new {|h,k| h[k] = [] }

    list.each {|(_s,y,x,n)|
      hash[[y,x]] << n
    }
# puts hash.inspect
    hash.select {|k,v|
      v.size == 2
    }
  end

  def to_s(y:nil,x:nil)
    str = "#{@cols}x#{@rows}\n\n"
    @grid.each.with_index(0) do |row,dy|
      row.each_char.with_index(0) do |cel,dx|
        if y && y == dy && x && x == dx
          str << `tput smso`
          str << row[dx]
          str << `tput rmso`
        else
          str << row[dx]
        end
      end
      str << "\n"
    end
    str << "\nsymbols: #{@symbols}"
  end

  # def gears # pairs of part numbers touching *

  # end

end

grid = Schematic.new

part1 = 0
part2 = nil
input.each_line(chomp: true) do |line|
  puts line if debugging
  grid << line
end
puts grid if debugging

# puts grid.part_numbers.inspect

grid.part_numbers {|part| part1 += part }

puts "Part 1: ", part1
if testing && expected
  if expected == part1
    puts "GOOD"
  else
    puts "Expected #{expected}"
    exit 1
  end
end

puts grid.gears if debugging

part2 = grid.gears.values.map {|(g1,g2)| g1*g2 }.sum

puts "Part 2: ", part2
if testing && expected2
  if expected2 == part2
    puts "GOOD"
  else
    puts "Expected #{expected2}"
    exit 1
  end
end
