require_relative "../lib/memo_storable.rb"
require_relative "../lib/memo_file_store.rb"

class Memo
  extend MemoStorable
  attr_accessor :memo_id, :content, :created_at, :updated_at
  store_strategy MemoFileStore.new
end
