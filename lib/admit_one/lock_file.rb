module AdmitOne
    
  class LockFile
    require 'tempfile'
    
    attr_accessor :filename
    
    def initialize(name,&block)
      @filename = "#{name}.lock"
      begin
        lock!
        yield
      ensure
        unlock!
      end
    end
    
    def full_path
      "#{Dir.tmpdir}/#{filename}"
    end
    
    def lock!
      File.open(full_path, "a") { |file| file.write("#{Process.pid}\n") }
      raise LockFileAlreadyExists unless lock_file_acquired?
    end
    
    def unlock!
      begin
        File.delete(full_path) if lock_file_acquired? 
      rescue
        raise LockFileMissing
      end
    end
    
    def lock_file_acquired?
      File.open(full_path, "r") { |file| file.gets.to_i == Process.pid }
    end
  end
  
  class LockFileAlreadyExists < StandardError; end
  class LockFileMissing < StandardError; end
end