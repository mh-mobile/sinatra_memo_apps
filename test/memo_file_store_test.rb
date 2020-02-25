require "minitest/autorun"
require "faker"
require "parallel"
require_relative "../lib/memo_file_store.rb"

class MemoFileStoreTest < Minitest::Test 
    def setup
      @memo_path = "test/memo.json"

      # テスト用のjsonファイルが存在する場合は削除する
      File.delete(@memo_path) if File.exist?(@memo_path)

      # MemoFileStoreインスタンスを初期化
      @memo_file_store = MemoFileStore.new(@memo_path)
    end

    def test_memo_insertion_by_multithread
        # メモの保存数が0であることい
        memos = @memo_file_store.findAll
        assert_equal 0, memos.count

        # 10スレッドを生成して、メモを500件追加
        Parallel.each(1..500, in_threads: 10) do
          @memo_file_store.create("#{Faker::Lorem.paragraph(sentence_count: 20)}")
        end

        # メモの保存数が500であること
        memos = @memo_file_store.findAll
        assert_equal 500, memos.count

        # 最後に追加されたメモのIDが500であること
        assert_equal 500, memos.last["memo_id"]

        # 最後から２番目に追加されたメモのIDが499であること
        assert_equal 499, memos[-2]["memo_id"]
    end

    def teardown
      # テスト用のjsonファイルを削除する
      File.delete(@memo_path) if File.exist?(@memo_path)
    end
end
