require 'minitest/autorun'
require 'minitest/reporters'
require_relative '../test/student'

Minitest::Reporters.use! [
  Minitest::Reporters::SpecReporter.new,
  Minitest::Reporters::JUnitReporter.new,
  Minitest::Reporters::HtmlReporter.new(
    reports_dir: 'unit_test/reports',
    reports_filname: 'test_results.html',
    clean:false,
    add_timestamp: true
  )
]

class TestStudent < Minitest::Test
  def setup
    Student.class_variable_set(:@@students, [])
    @student = Student.new('Smith', 'Andrew', '2000-04-15')
  end

  def test_initialization
    assert_equal 'Smith', @student.surname
    assert_equal 'Andrew', @student.name
    assert_equal Date.new(2000, 4, 15), @student.date_of_birth
  end

  def test_calculate_age
    expected_age = Date.today.year - 2000
    expected_age -= 1 if Date.today.yday < Date.new(2000, 4, 15).yday
    assert_equal expected_age, @student.calculate_age
  end

  def test_duplicate_prevention
    duplicate_student = Student.new('Smith', 'Andrew', '2000-04-15')
    assert_equal 1, Student.all_students.size
  end

  def test_get_students_by_age
    Student.new('Holod', 'Sam', '1998-06-21')
    students_age_24 = Student.get_students_by_age(@student.calculate_age)
    assert_includes students_age_24, @student
  end

  def test_remove_student
    Student.remove_student(@student)
    refute_includes Student.all_students, @student
  end

  def test_date_validation
    assert_raises(ArgumentError) { Student.new('Smith', 'Andrew', Date.today + 1) }
  end
end
