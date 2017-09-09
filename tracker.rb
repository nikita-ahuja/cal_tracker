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



