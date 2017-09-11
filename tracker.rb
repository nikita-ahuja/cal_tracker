# Calorie Tracker

require 'sqlite3'

$db_tracker = SQLite3::Database.new("cal_tracker.db")

create_cal_tracker = <<-SQL
  CREATE TABLE IF NOT EXISTS cal_tracker(
    id INTEGER PRIMARY KEY,
    weekday_id INT,
    cals_eaten INT,
    cals_lost INT,
    deficit BOOLEAN,
    worked_out BOOLEAN,
    FOREIGN KEY(weekday_id) REFERENCES days(id)
  )
SQL

# create a days of the week table (foreign key ref in calorie tracker table)

create_days_table = <<-SQL
  CREATE TABLE IF NOT EXISTS days_of_the_week(
    id INTEGER PRIMARY KEY,
    weekday VARCHAR (255)
  )
SQL

def add_days(weekday)
  $db_tracker.execute("INSERT INTO days_of_the_week (weekday) VALUES (?)", [weekday])
end

$db_tracker.execute(create_cal_tracker)
$db_tracker.execute(create_days_table)
days_array = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
days_array.each do |weekday|
  add_days(weekday)
end #end the .each loop



def value_updater()
    puts "Update your statistics for the day!"
    puts "Whats the day of the week? \n
    Type 1 for Sunday, 2 for Monday, 3 for Tuesday, 4 for Wednesday, 5 for Thursday, 6 for Friday, and 7 for Saturday."
    weekday = gets.chomp.to_i
    puts "How many calories did you eat today? (If you aren't sure how many calories were in a specific food you ate, please type 'lookup' to look up the foods in our database!)"
    $eat_value = gets.chomp
    if $eat_value == "lookup"
      food_lookup()
    end
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

    $db_tracker.execute("INSERT INTO cal_tracker(weekday_id, cals_eaten, cals_lost, deficit, worked_out) VALUES (?, ?, ?, ?, ?)", [weekday, $eat_value.to_i, lostcal_value.to_i, def_bool, wo_bool])
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
value_updater()



# SELECT cal_tracker.weekday_id, cal_tracker.cals_eaten, cal_tracker.cals_lost, cal_tracker.deficit, cal_tracker.worked_out, days_of_the_week.weekday FROM cal_tracker JOIN days_of_the_week ON cal_tracker.weekday_id = days_of_the_week.id;

# 1|2000|1500|false|false|Sunday












