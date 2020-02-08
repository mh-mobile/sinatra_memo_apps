# frozen_string_literal: true

require "json"
require "time"

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
      unless updated_memo.nil?
        updated_memo["content"] = content
        updated_memo["updated_at"] = Time.now.iso8601
      end
      JSON.dump(json, file)
    end
  end

  def create(content)
    json = load(file_path)
    File.open(file_path, "w") do |file|
      memo_id = Proc.new do
        json.empty? ? 1 : json.last["memo_id"] + 1
      end.call

      currentTime = Time.now.iso8601
      created_item = {
        memo_id: memo_id,
        content: content,
        created_at: currentTime,
        updated_at: currentTime
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
