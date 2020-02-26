# frozen_string_literal: true

require "json"
require "time"
require_relative "memo_file_lock.rb"

class MemoFileStore
  attr_reader :file_path

  def initialize(file_path)
    @file_path = file_path

    unless File.exist?(@file_path)
      MemoFileLock.synchronized(@file_path, "w") do |file|
        JSON.dump([], file)
      end
    end
  end

  def find_all
    MemoFileLock.synchronized(@file_path, "r") do |file|
      load_json(file)
    end
  end

  def find(memo_id)
    MemoFileLock.synchronized(file_path, "r") do |file|
      json = load_json(file)
      json.find do |memo|
        memo["memo_id"] == memo_id
      end
    end
  end

  def delete(memo_id)
    MemoFileLock.synchronized(file_path, "r+") do |file|
      json = load_json(file)
      prepare_to_write(file) do
        updated_json = json.reject do |memo|
          memo["memo_id"] == memo_id
        end
        JSON.dump(updated_json, file)
      end
    end
  end

  def update(memo_id, content)
    MemoFileLock.synchronized(file_path, "r+") do |file|
      json = load_json(file)
      prepare_to_write(file) do
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
  end

  def create(content)
    MemoFileLock.synchronized(file_path, "r+") do |file|
      json = load_json(file)
      prepare_to_write(file) do
        memo_id = Proc.new do
          json.empty? ? 1 : json.last["memo_id"] + 1
        end.call

        current_time = Time.now.iso8601
        created_item = {
          "memo_id" => memo_id,
          "content" => content,
          "created_at" => current_time,
          "updated_at" => current_time,
        }

        json << created_item
        JSON.dump(json, file)
        memo_id
      end
    end
  end

  private
    def load_json(file)
      JSON.load(file)
    end

    def prepare_to_write(file)
      file.rewind
      yield(file)
    ensure
      file.flush
      file.truncate(file.pos)
    end
end
