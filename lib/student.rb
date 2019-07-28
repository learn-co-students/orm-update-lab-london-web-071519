require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_accessor :name, :grade, :id

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id

  end

  def self.create_table
      sql =  <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
        )
        SQL
      DB[:conn].execute(sql) 
  end

  def self.drop_table
    sql =  <<-SQL
      DROP TABLE students
        SQL
      DB[:conn].execute(sql) 
  end

  def save 
    if @id
      update
    else
    sql =  <<-SQL
      INSERT INTO students (name, grade) VALUES (?, ?)
        SQL
      DB[:conn].execute(sql, @name, @grade)
      @id =  DB[:conn].execute("SELECT id FROM students ORDER BY ID DESC LIMIT 1")[0][0]
    end
  end

  def self.create(name, grade)
    new_student = self.new(name, grade)
    new_student.save
    new_student
  end

  def self.new_from_db(input)
      self.new(input[1], input[2], input[0])
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ? LIMIT 1"
    result = DB[:conn].execute(sql, name)[0]
    student = self.new(result[1], result[2], result[0])
    student
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, @name, @grade, @id)
  end

end
