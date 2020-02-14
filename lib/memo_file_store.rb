# frozen_string_literal: true

require "json"
require "time"
require_relative "memo_file_lock.rb"

class MemoFileStore
  attr_reader :file_path

  def initialize(file_path)
    @file_path = file_path

    unless File.exist?(@file_path)
      MemoFileLock.synchronized(@file_path, "w") do |w_file|
        JSON.dump([], w_file)
      end
    end
  end

  def findAll
    MemoFileLock.synchronized(@file_path, "r") do |r_file|
      load_json(r_file)
    end
  end

  def find(memo_id)
    MemoFileLock.synchronized(file_path, "r") do |r_file|
      json = load_json(r_file)
      json.find do |memo|
        memo["memo_id"] == memo_id
      end
    end
  end

  def delete(memo_id)
    MemoFileLock.synchronized(file_path, "r") do |r_file|
      json = load_json(r_file)
      File.open(file_path, "w") do |w_file|
        updated_json = json.reject do |memo|
          memo["memo_id"] == memo_id
        end
        JSON.dump(updated_json, w_file)
      end
    end
  end

  def update(memo_id, content)
    MemoFileLock.synchronized(file_path, "r") do |r_file|
      json = load_json(r_file)
      File.open(file_path, "w") do |w_file|
        updated_memo = json.find do |memo|
          memo["memo_id"] == memo_id
        end
        unless updated_memo.nil?
          updated_memo["content"] = content
          updated_memo["updated_at"] = Time.now.iso8601
        end
        JSON.dump(json, w_file)
      end
    end
  end

  def create(content)
    MemoFileLock.synchronized(file_path, "r") do |r_file|
      json = load_json(r_file)
      File.open(file_path, "w") do |w_file|
        memo_id = Proc.new do
          json.empty? ? 1 : json.last["memo_id"] + 1
        end.call

        currentTime = Time.now.iso8601
        created_item = {
          "memo_id" => memo_id,
          "content" => content,
          "created_at" => currentTime,
          "updated_at" => currentTime,
        }

        json << created_item
        JSON.dump(json, w_file)
        created_item
      end
    end
  end

  private
    def load_json(r_file)
      JSON.load(r_file)
    end
end
