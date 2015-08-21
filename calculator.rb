require 'colorize'

class String
  def is_number?
    true if Float(self) rescue false
  end
end

def find_operation(ops)
  puts "Please choose the number associated with your desired operation...".green

  ops.keys.each_with_index do |key, index|
    puts "#{index + 1}. #{key}".light_blue
  end
  operation = gets.chomp

  if !operation.is_number? || (operation.to_i < 1 || operation.to_i > ops.length)
    puts
    puts "You had one job...".red
    find_operation(ops)
  else
    puts
    return operation.to_i - 1
  end
end

def find_num(msg)
  puts msg.green
  val = gets.chomp

  if !val.is_number?
    puts
    puts "Bro... '#{val}' ain't no number.".red
    find_num(msg)
  end
  puts
  return val.to_f
end

def calculate(opIndex, num1, num2)
  if opIndex == 0
    if num1 == 9 && num2 == 10
      return 21
    else
      return num1 + num2
    end
  elsif opIndex == 1
    return num1 - num2
  elsif opIndex == 2
    return num1 * num2
  elsif opIndex == 3
    if num2 == 0
      return "undefined"
    else
      return num1 / num2
    end
  else
    if opIndex == 5
      num2 = (1.0 / num2)
    end
    return num1 ** num2
  end
end

def run_calcbot(ops)
  puts "Please choose your desired input mode...".green
  puts "1. Step-by-Step".light_blue
  puts "2. Raw Expression".light_blue
  response = gets.chomp

  if !response.is_number? || (response.to_i < 1 || response.to_i > 2)
    puts
    puts "You had one job...".red
    run_calcbot(ops)
  else
    response = response.to_i
  end

  if response == 1
    puts
    puts "Step-by-Step Input Method selected!".yellow
    puts
    run_calcbot_auto(ops)
  else
    puts
    puts "Raw Expression Input Method selected!".yellow
    puts
    puts "Please type the expression to simplify...".green
    expression = gets.chomp

    begin
      solution = eval(expression)
    rescue SyntaxError
      puts
      puts "Sorry! You've entered an expression with a variable and/or an invalid symbol! Please try again...".red
      run_calcbot(ops)
    end

    puts
    puts "Solution: '#{expression}' simplifies to #{solution}".yellow
    ask_calculation_repeat(ops)
  end
end

def run_calcbot_auto(ops)
  operation_index = find_operation(ops)
  x1 = find_num("Please enter a number...")
  x2 = find_num("Please enter another number...")
  puts "Solution: #{x1} #{ops.values[operation_index]} #{x2} is #{calculate(operation_index, x1, x2)}".yellow
  ask_calculation_repeat(ops)
end

def ask_calculation_repeat(ops)
  puts
  puts "Would you like to perform another calculation? (Y/N)".green
  response = gets.downcase.chomp

  if response == "y"
    puts
    run_calcbot(ops)
  else
    puts
    puts "Thanks for using #{"C".red}#{"a".yellow}#{"l".green}#{"c".cyan}#{"B".blue}#{"o".magenta}#{"t".light_magenta}!"
    puts "Powering down...".light_red
  end
end

puts
puts "--------------------"
puts
puts "Hello, I am #{"C".red}#{"a".yellow}#{"l".green}#{"c".cyan}#{"B".blue}#{"o".magenta}#{"t".light_magenta} v1.3!"
puts
operations = {
  "Addition" => "plus",
  "Subtraction" => "minus",
  "Multiplication" => "multiplied by",
  "Division" => "divided by",
  "Exponentiation" => "to the power of",
  "Rooting" => "root"
}
run_calcbot(operations)
puts "--------------------"