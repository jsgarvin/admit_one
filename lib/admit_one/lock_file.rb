module AdmitOne
  
  class LockFile
    require 'tempfile'
    
    attr_accessor :name, :lock_file
    
    def initialize(name,&block)
      @name = name
      if lock! then
        begin
          yield
        ensure
          unlock!
        end
      end
    end
    
    #######
    private
    #######
    
    def full_path
      "#{Dir.tmpdir}/#{name}.lock"
    end
    
    def lock!
      @lock_file = File.open(full_path, "a+")
      lock_file.write("#{Process.pid}\n")
      lock_file.flush
      lock_file.rewind
      raise(LockFailure,'already locked by other process') unless lock_file.gets.to_i == Process.pid
      return true
    end
    
    def unlock!
      lock_file.close
      begin
        File.delete(full_path)
      rescue
        # This should never happen. It would indicate that another process deleted
        # a lock file that it didn't rightfully own, or that a user deleted it manually
        # before this process completed. 
        raise LockFileMissing, 'Lockfile unexpectedly vanished! This should probably be investigated!'
      end
    end
    
  end
  
  class LockFailure < StandardError; end
  class LockFileMissing < StandardError; end
end