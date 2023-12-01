# --- Day 1: Trebuchet?! ---

# Something is wrong with global snow production, and you've been selected to take a look. The
# Elves have even given you a map; on it, they've used stars to mark the top fifty locations that
# are likely to be having problems.
#
# You've been doing this long enough to know that to restore snow operations, you need to check
# all fifty stars by December 25th.
#
# Collect stars by solving puzzles.  Two puzzles will be made available on each day in the Advent
# calendar; the second puzzle is unlocked when you complete the first.  Each puzzle grants one
# star. Good luck!
#
# You try to ask why they can't just use a weather machine ("not powerful enough") and where
# they're even sending you ("the sky") and why your map looks mostly blank ("you sure ask a lot of
# questions") and hang on did you just say the sky ("of course, where do you think snow comes
# from") when you realize that the Elves are already loading you into a trebuchet ("please hold
# still, we need to strap you in").
#
# As they're making the final adjustments, they discover that their calibration document (your
# puzzle input) has been amended by a very young Elf who was apparently just excited to show off
# her art skills. Consequently, the Elves are having trouble reading the values on the document.
#
# The newly-improved calibration document consists of lines of text; each line originally
# contained a specific calibration value that the Elves now need to recover. On each line, the
# calibration value can be found by combining the first digit and the last digit (in that order)
# to form a single two-digit number.
#
# For example:
#
# 1abc2
# pqr3stu8vwx
# a1b2c3d4e5f
# treb7uchet
#
# In this example, the calibration values of these four lines are 12, 38, 15, and 77. Adding these together produces 142.
#
# Consider your entire calibration document. What is the sum of all of the calibration values?
#

# --- Part Two ---

# Your calculation isn't quite right. It looks like some of the digits are actually spelled out
# with letters: one, two, three, four, five, six, seven, eight, and nine also count as valid
# "digits".

# Equipped with this new information, you now need to find the real first and last digit on each line. For example:

# two1nine
# eightwothree
# abcone2threexyz
# xtwone3four
# 4nineeightseven2
# zoneight234
# 7pqrstsixteen

# In this example, the calibration values are 29, 83, 13, 24, 42, 14, and 76. Adding these together produces 281.

# What is the sum of all of the calibration values?


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
  1abc2
  pqr3stu8vwx
  a1b2c3d4e5f
  treb7uchet
  END
  expected = 142
  expected = nil

  input = <<~END
  two1nine
  eightwothree
  abcone2threexyz
  xtwone3four
  4nineeightseven2
  zoneight234
  7pqrstsixteen
  END

  expected2 = 281
else
  puts "solving day #{day} from input"
end

part1 = 0
part2 = 0
numbers = {
  "one" => 1,
  "two" => 2,
  "three" =>3,
  "four" => 4,
  "five" => 5,
  "six" => 6,
  "seven" => 7,
  "eight" => 8,
  "nine" => 9,
}
revnums = numbers.transform_keys {_1.reverse}
input.each_line(chomp: true) do |line|
  puts line if debugging

  digits = line.scan(/\d/).join
  part1 += 10*digits[0].to_i + digits[-1].to_i

  re = /(#{numbers.keys.join("|")})/
  nums = line.gsub(re, numbers)
  er = /(#{revnums.keys.join("|")})/
  revs = line.reverse.gsub(er, revnums)
  puts nums,revs if debugging

  digits = nums.scan(/\d/).join
  tigids = revs.scan(/\d/).join
  cal = 10*digits[0].to_i + tigids[0].to_i
  puts cal,nil if debugging
  part2 += cal
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
