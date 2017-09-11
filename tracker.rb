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
    weekday INT,
    cals_eaten INT,
    cals_remaining INT,
    cals_lost INT,
    deficit BOOLEAN,
    worked_out BOOLEAN,
    FOREIGN KEY(weekday) REFERENCES days(id)
  )
SQL

$db_tracker.execute(create_cal_tracker)


def value_updater()
    puts "Update your statistics for the day!"
    puts "How many calories did you eat today? If you aren't sure how many calories you ate, "
    eat_value = gets.chomp.to_i
    $db_tracker.execute("INSERT INTO cal_tracker(cals_eaten) VALUES (?)", [eat_value])
    puts "How many calories have you lost today (resting and active?)"
    lostcal_value = gets.chomp.to_i
    $db_tracker.execute("INSERT INTO cal_tracker(cals_eaten) VALUES (?)", [lostcal_value])
    puts "Have you worked out today (y/n)?"
    wo_value = gets.chomp.to_s
      if wo_value == "y"
          $db_tracker.execute("INSERT INTO cal_tracker(worked_out) VALUES (?)", ["true"])
          # break
      elsif wo_value == "n"
        $db_tracker.execute("INSERT INTO cal_tracker (worked_out) VALUES (?)", ["false"])
        # break
      else
        while wo_value != "y" || "n"
          puts "Please enter either 'y' or 'n'"
          wo_value = gets.chomp.to_s
        end
  end
end

def food_cal_lookup(food)

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












