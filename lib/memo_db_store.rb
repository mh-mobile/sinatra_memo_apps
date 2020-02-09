# frozen_string_literal: true

require "pg"
require "yaml"
require "erb"
require "dotenv"

class MemoDbStore
  attr_accessor :connection
  attr_accessor :db_config

  def initialize(db_config_path)
    Dotenv.load
    @db_config = YAML.load(ERB.new(File.read(db_config_path)).result)["db"]
  end

  def findAll
    connection = PG.connect(db_config)
    results = connection.exec("select * from memos")
    results.map(&method(:convert))
  rescue PG::Error => e
    puts e.message
  ensure
    connection.close if connection
  end

  def find(memo_id)
    connection = PG.connect(db_config)
    results = connection.exec_params("select * from memos where id = $1", [memo_id])
    convert(results.first) if results.first
  rescue PG::Error => e
    puts e.message
  ensure
    connection.close if connection
  end

  def delete(memo_id)
    connection = PG.connect(db_config)
    connection.exec_params("delete from memos where id = $1", [memo_id])
  rescue PG::Error => e
    puts e.message
  ensure
    connection.close if connection
  end

  def update(memo_id, content)
    connection = PG.connect(db_config)
    connection.exec_params("update memos set content = $1, updated_at = $2 where id = $3", [content,  Time.now.iso8601, memo_id])
  rescue PG::Error => e
    puts e.message
  ensure
    connection.close if connection
  end

  def create(content)
    connection = PG.connect(db_config)
    connection.exec_params("insert into memos (content, created_at, updated_at) values ($1, $2, $3)", [content, Time.now.iso8601, Time.now.iso8601])
    results = connection.exec("select LASTVAL() from memos")
    results = connection.exec_params("select * from memos where id = $1", [results.first["id"]])
    convert(results.first) if results.first
  rescue PG::Error => e
    puts e.message
  ensure
    connection.close if connection
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
