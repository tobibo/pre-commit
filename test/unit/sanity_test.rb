require 'minitest_helper'
require 'pre-commit/checks/sanity'

class SanityTest < MiniTest::Unit::TestCase

  add_setup_hook {
    system("mkdir test/files/repo > /dev/null")
    system("git init test/files/repo > /dev/null")
  }

  add_teardown_hook {
    system("rm -rf test/files/repo > /dev/null")
  }

  def test_should_not_detect_bad_character_in_local_files
    Dir.chdir("test/files/repo") do
      %w(1 2).each do |number|
        system("cp ../bad_file_#{number}.css . > /dev/null")
      end
      check = Sanity.new
      assert !check.detected_bad_code?, 'should not detect bad character'
    end
  end

  def test_should_detect_bad_character
    Dir.chdir("test/files/repo") do
      %w(1 2).each do |number|
        system("cp ../bad_file_#{number}.css . > /dev/null")
      end
      system("git add .")
      check = Sanity.new
      assert check.detected_bad_code?, 'should detect bad character'
    end
  end

  def test_should_pass_a_valid_file
    Dir.chdir("test/files/repo") do
      check = Sanity.new
      system("cp ../valid_file.rb . > /dev/null")
      system("git add .")
      assert !check.detected_bad_code?, 'should pass valid files'
    end
  end

  def test_check_should_pass_if_staged_file_list_is_empty
    Dir.chdir("test/files/repo") do
      check = Sanity.new
      assert check.run
    end
  end

end
