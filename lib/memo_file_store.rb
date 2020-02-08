# frozen_string_literal: true

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
    load(file_path)
  end

  def find(memo_id)
    json = load(file_path)
    json.find do |memo|
      memo["memo_id"] == memo_id
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
      updated_memo = json.find do |memo|
        memo["memo_id"] == memo_id
      end
      updated_memo["content"] = content unless updated_memo.nil?
      JSON.dump(json, file)
    end
  end

  def create(content)
    json = load(file_path)
    File.open(file_path, "w") do |file|
      memo_id = Proc.new do
        1 if json.empty?
        json.last["memo_id"] + 1
      end.call

      created_item = {
        memo_id: memo_id,
        content: content
      }

      json << created_item
      JSON.dump(json, file)
      created_item
    end
  end

  private
    def load(file_path)
      File.open(file_path, "r") do |file|
        JSON.load(file)
      end
    end
end
