# Calorie Tracker

require 'sqlite3'


tracker = SQLite3::Database.new("days_of_the_week.db")



# create a days of the week table (foreign key ref in calorie tracker table)
create_days_cmd = <<-SQL
  CREATE TABLE IF NOT EXISTS days_of_the_week(
    id INTEGER PRIMARY KEY,
    day VARCHAR (255)
  )
SQL


