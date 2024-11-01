require 'date'

class Student
  attr_reader :surname, :name, :date_of_birth

  @@students = []

  def initialize(surname,name,date_of_birh)
    @surname = surname
    @name = name
    @date_of_birth = validate_date_of_birth(date_of_birth)
    add_student unless duplicate?
  end

  def canculate_age
    today = Date.today
    age = today.year - @date_of_birth.year
    age -= 1 if today.yday < @date_of_birth.yday
    age
  end

  def add_student
    @@students << self
  end

  def self.remove_student(student)
    @@students.delete(student)
  end

  def self.get_students_by_age(age)
    @@students.select { |student| student.canculate_age == age }
  end

  def self.get_student_by_name(name)
    @@student.select { |student| student.name == name }
  end

  def self.all_student
    @@students
  end

  private

  def validate_date_of_birth(date)
    parsed_date = Date.parse(date.to_s)
    raise ArgumentError, 'Date of birthday must be in the past' if parsed_date > Date.today
    parsed_date
  end

  def duplicate?
    @@students.any? do |student|
      student.name == @name && student.surname == @surname && student.date_of_birth == @date_of_birth
    end
  end
end

student1 = Student.new('Smith', 'Andrew', '2000-04-15')
student2 = Student.new('Holod', 'Sam', '1998-06-21')
student3 = Student.new('Carpenter', 'Lisa', '2000-06-15')

puts "#{student1.name} #{student1.surname} year: #{student1.canculate_age}"

duplicate_student = Student.new('Smith', 'Andrew', '2000-04-15')
puts "Total students: #{Student.all_students.size}"

students_age_24 = Student.get_students_by_age(24)
puts "Students aged 24 years"
students_age_24.each { |student| puts "#{student.name} #{student.surname}" }

students_name_andrew = Student.get_students_by_name('Andrew')
puts "Students named Andrew"
students_named_andrew.each { |student| puts "#{student.name} #{student.surname}" }

Student.remove_student(student2)
puts "Total students after removal: #{Student.all_students.size}"  
