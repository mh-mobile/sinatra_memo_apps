# frozen_string_literal: true

require "pg"

module PGManager
  def self.open(config)
    connection = PG.connect(config)
    yield(connection)
  ensure
    connection.close if connection
  end
end
