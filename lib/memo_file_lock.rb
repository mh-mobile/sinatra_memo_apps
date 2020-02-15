# frozen_string_literal: true

class MemoFileLock
  def self.synchronized(file_path, mode)
    File.open(file_path, mode) do |file|
      file.flock(File::LOCK_EX)
      yield(file)
    end
  end
end
