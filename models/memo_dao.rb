# frozen_string_literal: true

require_relative "../lib/memo_storable.rb"
require_relative "../lib/memo_db_store.rb"

class MemoDao
  extend MemoStorable
  store_strategy MemoDbStore.new(File.dirname(__FILE__) + "/../resource/database.yml")
end
