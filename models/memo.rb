require_relative "../lib/memo_recordable.rb"
require_relative "../lib/memo_file_store.rb"

class Memo
  extend MemoRecordable
  attr_accessor :memo_id, :content, :created_at, :updated_at
  store_strategy MemoFileStore.new
end
