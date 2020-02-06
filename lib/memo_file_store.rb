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
    json = load(file_path)
    File.open(file_path, "r") do |file|
      memo = json.find do |memo|
        memo["memo_id"] == memo_id
      end
    end
  end

  def delete(memo_id)
    json = load(file_path)
    File.open(file_path, "w") do |file|
      updated_json = json.reject do |memo|
        memo["memo_id"] == memo_id
      end
      JSON.dump(updated_json, file)
    end
  end

  def update(memo_id, content)
    json = load(file_path)
    File.open(file_path, "w") do |file|
      memo = json.find do |memo|
        memo["memo_id"] == memo_id
      end
      memo["content"] = content unless memo.nil?
      JSON.dump(json, file)
    end
  end

  def create(content)
    json = load(file_path)
    File.open(file_path, "w") do |file|
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
