# frozen_string_literal: true

require "pg"

module PGManager
  def self.open(config)
    connection = PG.connect(config)
    if block_given?
      yield(connection)
    else
      connection
    end
  ensure
    if block_given?
      connection.close if connection
    end
  end
end
