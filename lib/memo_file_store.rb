require "json"

class MemoFileStore

  attr_reader :file_path

  def initialize(file_path)
    @file_path = file_path 

    unless File.exist?(@file_path)
      File.open(file_path, "w") do |file|
        JSON.dump([], file)
      end
    end
  end

  def findAll
    File.open(file_path) do |file|
      JSON.load(file)
    end
  end

  def find(memo_id)
    File.open(file_path, "r") do |file|
      json = load(file_path)
      json.find do |memo|
        memo["memo_id"] == memo_id
      end
    end
  end

  def delete(memo_id)
    File.open(file_path, "w") do |file|
      json = load(file_path)
      updated_json = json.reject do |memo|
        memo["memo_id"] == memo_id
      end
      JSON.dump(updated_json, file)
    end
  end

  def update(memo_id, content)
    File.open(file_path, "w") do |file|
      json = load(file_path)
      memo = json.find do |memo|
        memo["memo_id"] == memo_id
      end
      memo["content"] = content unless memo.nil?
      JSON.dump(json, file)
    end
  end

  def create(content)
    File.open(file_path, "w") do |file|
      json = load(file_path)
      memo_id = json.count + 1    
      json << { 
        memo_id: memo_id,
        content: content
      }
      JSON.dump(json, file)
    end
  end

  private 

  def load(file_path)
    File.open(file_path, "r") do | file|
      JSON.load(file)
    end
  end
    
end
