# Calorie Tracker

require 'sqlite3'


db_days = SQLite3::Database.new("days.db")

# create a days of the week table (foreign key ref in calorie tracker table)
create_days_table = <<-SQL
  CREATE TABLE IF NOT EXISTS days(
    id INTEGER PRIMARY KEY,
    weekday VARCHAR (255)
  )
SQL

db_days.execute(create_days_table)

def add_days(db_days, weekday)
  db_days.execute("INSERT INTO days (weekday) VALUES (?)", [weekday])
end

days_array = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
days_array.each do |weekday|
  add_days(db_days, weekday)
end

$db_tracker = SQLite3::Database.new("cal_tracker.db")

create_cal_tracker = <<-SQL
  CREATE TABLE IF NOT EXISTS cal_tracker(
    id INTEGER PRIMARY KEY,
    weekday_id INT,
    cals_eaten INT,
    cals_remaining INT,
    cals_lost INT,
    deficit BOOLEAN,
    worked_out BOOLEAN,
    FOREIGN KEY(weekday_id) REFERENCES days(id)
  )
SQL

$db_tracker.execute(create_cal_tracker)

def value_updater()
    puts "Update your statistics for the day!"
    # puts "Whats the day of the week?"
    #   weekday = gets.chomp
    puts "How many calories did you eat today? (If you aren't sure how many calories were in a specific food you ate, please type 'lookup' to look up the foods in our database!)"
    $eat_value = gets.chomp
    if $eat_value == "lookup"
      food_lookup()
    end
    remaining = (1500 - $eat_value.to_i)
    puts "You have #{remaining} calories remaining for the day since you are on a 1500 calorie diet."
    puts "How many calories have you lost today (resting and active?)"
    lostcal_value = gets.chomp
    puts "Have you worked out today (y/n)?"
    wo_value = gets.chomp.to_s
      if wo_value == "y"
        wo_bool = "true"
      elsif wo_value == "n"
        wo_bool = "false"
      else
        while wo_value != "y" || "n"
          puts "Please enter either 'y' or 'n'"
          wo_value = gets.chomp
        end
      end
    if $eat_value < lostcal_value
      def_bool = "true"
    else
      def_bool = "false"
    end

    $db_tracker.execute("INSERT INTO cal_tracker(weekday, cals_eaten, cals_lost, deficit, worked_out) VALUES (?, ?, ?, ?, ?)", [$eat_value.to_i, remaining.to_i, lostcal_value.to_i, def_bool, wo_bool])
end

def food_lookup() #food => calorie value
   food_database =
  {"1 apple" => 90,
   "1 orange" => 80,
   "1 serving broccoli" => 100,
   "1 cup of soup" => 100..300,
   "1 serving Nature Valley granola bars" => 190,
   "1 serving salmon (grilled)" => 250,
   "1 serving salmon (pan fried)" => 650,
   "1 cup of rice" => 200,
   "1 cup of cereal" => 230
  }

  puts "What food would you like to look up? (Ex: '1 serving broccoli')."
  input = gets.chomp
  loop do
  while input.to_i == 0
    food_database.each do |food, calories|
      if food_database.include?(input)
        puts "#{food} is #{calories} calories. We will add that to your total for the day!"
        $eat_value += food[calories.to_i]
        puts "Your current calorie value for the day is #{$eat_value}. If you would like to add more, please enter a calorie number now. If you would like to lookup another item, type the entry."
        input = gets.chomp
      else # if the database doesnt include the food
      puts "Sorry that food is not in our database! Feel free to refer to the web or make an educated guess. When you come to a conclusion, enter the appropriate amount of calories."
      $eat_value += gets.chomp.to_i
      end
    end
  end
end

end










  # look up the food in the hash
  # if it is in the hash, make eat_value == to the calories associated with the food
  #if the food is not in the database, say it's not and to make an educated guess


# puts <<-STRING
#   Update your statistics for the day!:
#   What were your calories eaten?
#   cals_eat
#   What value would you like to update for today?
#   Enter "1" for calories eaten.
#   Enter "2" for calories lost.
#   Enter "3" for work out.
# STRING

# $value = gets.chomp.to_i

value_updater()












