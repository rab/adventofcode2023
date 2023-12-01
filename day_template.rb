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
  END
  expected = nil
  expected2 = nil
else
  puts "solving day #{day} from input"
end

part1 = 0
part2 = nil
input.each_line(chomp: true) do |line|
  puts line if debugging
end

puts "Part 1: ", part1
if testing && expected
  if expected == part1
    puts "GOOD"
  else
    puts "Expected #{expected}"
    exit 1
  end
end

puts "Part 2: ", part2
if testing && expected2
  if expected2 == part2
    puts "GOOD"
  else
    puts "Expected #{expected2}"
    exit 1
  end
end
