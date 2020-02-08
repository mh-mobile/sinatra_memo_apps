require_relative "../lib/memo_storable.rb"
require_relative "../lib/memo_file_store.rb"

class MemoDao 
  extend MemoStorable
  store_strategy MemoFileStore.new("resource/memo.json")
end