
gem install sqlite3

require 'sqlite3'

class User
  def initialize
    @db = SQLite3::Database.new('db.sql')
    create_table_if_not_exists
  end

  def create(user_info)
    # TODO: Implement this method
  end

  def find(user_id)
    # TODO: Implement this method
  end

  def all
    # TODO: Implement this method
  end

  def update(user_id, attribute, value)
    # TODO: Implement this method
  end

  def destroy(user_id)
    # TODO: Implement this method
  end

  def create_table_if_not_exists
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firstname TEXT,
        lastname TEXT,
        age INTEGER,
        password TEXT,
        email TEXT
      );
    SQL
    @db.execute(sql)
  end
end

def create(user_info)
    sql = <<-SQL
      INSERT INTO users (firstname, lastname, age, password, email)
      VALUES (?, ?, ?, ?, ?);
    SQL
    @db.execute(sql, user_info[:firstname], user_info[:lastname], user_info[:age], user_info[:password], user_info[:email])
    user_id = @db.last_insert_row_id
    return user_id > 0 ? user_id : nil
  end

  def find(user_id)
    sql = <<-SQL
      SELECT * FROM users WHERE id = ?;
    SQL
    row = @db.get_first_row(sql, user_id)
    return row ? { id: row[0], firstname: row[1], lastname: row[2], age: row[3], password: row[4], email: row[5] } : nil
  end
end