require 'minitest/autorun'
require 'minitest/reporters'
require_relative '../test/student'

Minitest::Reporters.use! [
  Minitest::Reporters::SpecReporter.new,
  Minitest::Reporters::JUnitReporter.new,
  Minitest::Reporters::HtmlReporter.new(
    reports_dir: 'spec_test/reports',
    reports_filname: 'test_results.html',
    clean:false,
    add_timestamp: true
  )
]

describe Student do
  before do
    Student.class_variable_set(:@@students, []) 
    @student = Student.new('Smith', 'Andrew', '2000-04-15')
  end

  it 'correctly initializes a student' do
    _(@student.surname).must_equal 'Smith'
    _(@student.name).must_equal 'Andrew'
    _(@student.date_of_birth).must_equal Date.new(2000, 4, 15)
  end

  it 'calculates age correctly' do
    expected_age = Date.today.year - 2000
    expected_age -= 1 if Date.today.yday < Date.new(2000, 4, 15).yday
    _(@student.calculate_age).must_equal expected_age
  end

  it 'prevents duplicate students from being added' do
    duplicate_student = Student.new('Smith', 'Andrew', '2000-04-15')
    _(Student.all_students.size).must_equal 1
  end

  it 'returns students by specified age' do
    Student.new('Holod', 'Sam', '1998-06-21')
    students_age_24 = Student.get_students_by_age(@student.calculate_age)
    _(students_age_24).must_include @student
  end

  it 'removes a student from the list' do
    Student.remove_student(@student)
    _(Student.all_students).wont_include @student
  end

  it 'raises an error for future date of birth' do
    _(proc { Student.new('Ivanov', 'Ivan', Date.today + 1) }).must_raise ArgumentError
  end
end
