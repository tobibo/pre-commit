require 'minitest_helper'
require 'pre-commit/checks/merge_conflict'

class MergeConflictTest < MiniTest::Unit::TestCase

  add_setup_hook {
    system("mkdir test/files/repo > /dev/null")
    system("git init test/files/repo > /dev/null")
  }

  add_teardown_hook {
    system("rm -rf test/files/repo > /dev/null")
  }

  def test_should_detect_a_merge_conflict
    Dir.chdir("test/files/repo") do
      check = MergeConflict.new
      system("cp ../merge_conflict.rb . > /dev/null")
      system("git add .")
      assert check.detected_bad_code?, 'We should prevent a merge conflict from being committed'
    end
  end

  def test_should_pass_a_file_with_no_merge_conflicts
    Dir.chdir("test/files/repo") do
      check = MergeConflict.new
      system("cp ../valid_file.rb . > /dev/null")
      system("git add .")
      assert !check.detected_bad_code?, 'A file with no merge conflicts should pass'
    end
  end

end
