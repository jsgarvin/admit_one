require File.expand_path('../../../lib/admit_one',  __FILE__)
require 'test/unit'

class LockFileTest < Test::Unit::TestCase
  
  def setup
    File.delete(lock_file_path) if File.exist?(lock_file_path)
  end
  
  def test_should_create_and_remove_lockfile
    AdmitOne::LockFile.new(:admit_one_lock_file_unit_test) do
      assert(File.exist?(lock_file_path))
    end
    assert(!File.exist?(lock_file_path))
  end
  
  def test_should_not_clobber_another_lock_file
    File.open(lock_file_path, "a") { |file| file.write("1\n") }
    assert_raise(AdmitOne::LockFileAlreadyExists) do
      AdmitOne::LockFile.new(:admit_one_lock_file_unit_test) do
        assert false #should never run
      end
    end
    assert(File.exist?(lock_file_path))
    File.delete(lock_file_path)
  end
  
  #######
  private
  #######
  
  def lock_file_path
    "#{Dir.tmpdir}/admit_one_lock_file_unit_test.lock"
  end
end