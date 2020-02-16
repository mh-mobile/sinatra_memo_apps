# frozen_string_literal: true

require "pg"
require "yaml"
require "erb"
require "dotenv"
require_relative "pg_manager.rb"

class MemoDbStore
  attr_reader :db_config

  def initialize(db_config_path)
    Dotenv.load
    @db_config = YAML.load(ERB.new(File.read(db_config_path)).result)["db"]
  end

  def findAll
    PGManager.open(db_config) do |connection|
      results = connection.exec("select * from memos")
      results.map(&method(:convert))
    end
  end

  def find(memo_id)
    PGManager.open(db_config) do |connection|
      results = connection.exec_params("select * from memos where id = $1", [memo_id])
      convert(results.first) if results.first
    end
  end

  def delete(memo_id)
    PGManager.open(db_config) do |connection|
      connection.exec_params("delete from memos where id = $1", [memo_id])
    end
  end

  def update(memo_id, content)
    PGManager.open(db_config) do |connection|
      connection.exec_params("update memos set content = $1, updated_at = $2 where id = $3", [content,  Time.now.iso8601, memo_id])
    end
  end

  def create(content)
    PGManager.open(db_config) do |connection|
      results = connection.exec_params("insert into memos (content, created_at, updated_at) values ($1, $2, $3) RETURNING id", [content, Time.now.iso8601, Time.now.iso8601])
      results.first["id"]
    end
  end

  private
    def convert(result_row)
      {
        "memo_id" => result_row["id"],
        "content" => result_row["content"],
        "created_at" => result_row["created_at"],
        "updated_at" => result_row["updated_at"]
      }
    end
end
