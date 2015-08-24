require "colorize"
require "io/console"

class SnapchatUser
  attr_reader :full_name, :username, :password, :my_story, :feed

  def initialize(full_name, username, password)
    @full_name = full_name
    @username = username
    @password = password
    @my_story = []
    @feed = []
  end

  def send_pic(image, user)
    @my_story.push(image)
    user.recieve_pic(image, self)
  end

  def recieve_pic(image, user)
    new_message = {
      :user => user.username,
      :picture => image,
      :timestamp => Time.now.strftime("%m/%d/%Y at %H:%M")
    }
    @feed.push(new_message)
  end
end

def check_username(registered_names)
  puts "Please enter a username...".green
  username = gets.chomp

  if registered_names.include?(username)
    puts "Sorry, but this username is already taken.".red
    puts
    check_username(registered_names)
  else
    return username
  end
end

def check_password
  puts "Please enter a password...".green
  pass1 = STDIN.noecho(&:gets).chomp
  puts
  puts "Please confirm your password...".green
  pass2 = STDIN.noecho(&:gets).chomp
  puts

  if pass1 != pass2
    puts "Invalid. Please re-enter your password...".light_red
    check_password()
  else
    puts "Password confirmed!".green
    puts
    return pass1
  end
end

def make_account(users, registered_names, prompt)
  response = "y"

  if prompt
    puts "Would you like to setup an account? (Y/N)".green
    response = gets.chomp.downcase
  end

  if response == "y" || response == "yes"
    puts
    puts "Please enter your full name...".green
    full_name = gets.chomp
    puts
    username = check_username(registered_names)
    registered_names.push(username)
    puts
    password = check_password()
    user = SnapchatUser.new(full_name, username, password)
    users.push(user)
    puts "Welcome to Snapchat, #{full_name.split(" ")[0]}!".yellow
    puts "------------"

    if users.length < 2
      puts "Please create another account!".green
      make_account(users, registered_names, false)
    else
      session_login(users, registered_names)
    end
  else
    puts "M8 wat u plain' @ get rekt n00b".light_red
  end
end

def session_login(users, registered_names)
  puts "Please login to a valid account!".yellow
  puts
  puts "Please enter a username...".green
  username = gets.chomp

  if registered_names.include?(username)
    puts
    user = session_password(username, users)
    puts
    puts "Welcome Back #{user.full_name.split(" ")[0]}!".yellow
    display_menu(user, users, registered_names)
  else
    puts "An account with username: #{username} has not been found.".red
    session_login(users, registered_names)
  end
end

def display_menu(user, users, registered_names)
  puts "------------"
  puts "Choose an option...".green
  puts "1. Send Message"
  puts "2. View Messages"
  puts "3. Logout"
  option = gets.chomp
  puts

  if option.to_i == 1
    puts "Please type your message...".green
    msg = gets.chomp
    puts
    send_message(user, msg, users, registered_names)
    display_menu(user, users, registered_names)
  elsif option.to_i == 2
    user.feed.each_with_index do |message, index|
      puts "  > #{"Message".yellow} #{("#".concat((index + 1).to_s)).yellow} #{"from".yellow} #{message[:user].green} #{"on".yellow} #{message[:timestamp].yellow}"
      puts "    - '#{message[:picture].light_magenta}'"
    end
    display_menu(user, users, registered_names)
  elsif option.to_i == 3
    puts "You have been logged out!".yellow
    puts "------------"
    session_login(users, registered_names)
  else
    puts "'#{option}' is not a valid action number!".light_red
    display_menu(user, users, registered_names)
  end
end

def send_message(sender, msg, users, registered_names)
  puts "Please type recipient...".green
  recipientName = gets.chomp
  recipient = nil
  flag = false

  users.each do |x|
    if recipientName == x.username
      recipient = x
      flag = true
    end
    break if flag
  end
  sender.send_pic(msg, recipient)
  puts
  puts "Your message to #{recipient.username} has been sent successfully!".yellow
end

def session_password(username, users)
  puts "Please enter the password...".green
  password = STDIN.noecho(&:gets).chomp
  flag = false
  user = nil

  users.each do |x|
    if username == x.username && x.password == password
      flag = true
      user = x
    end
    break if flag
  end

  if flag
    return user
  else
    puts "Invalid password!".red
    session_password(username, users)
  end
end

SESSION_USERS = []
SESSION_USERNAMES = []
def prompt_login(users, usernames)
  puts "------------"
  puts "Welcome to Snapchat!".yellow
  puts "Do you have an account? (Y/N)".green
  answer = gets.downcase.chomp
  puts

  if answer == "yes" || answer == "y"
    puts "Cool! Unfortunatly we do not have a database so you cannot log into your account. However you can enjoy this picture of a circus elephant that you can't see, but trust me it's there!!!".light_magenta
  end
  make_account(users, usernames, true)
end

prompt_login(SESSION_USERS, SESSION_USERNAMES)