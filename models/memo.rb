require_relative "memo_dao.rb"

class Memo
  attr_accessor :memo_id, :content, :created_at, :updated_at

  def self.findAll
    MemoDao.findAll.map(&method(:convert))
  end

  def self.find(memo_id)
    item = MemoDao.find(memo_id)
    convert(item) unless item.nil?
  end

  def self.delete(memo_id)
    MemoDao.delete(memo_id)
  end

  def self.update(memo_id, content)
    MemoDao.update(memo_id, content)
  end

  def self.create(content)
    item = MemoDao.create(content)
    convert(item) unless item.nil?
  end

  def self.convert(memo_item) 
    Memo.new.tap do |memo|
      memo.memo_id = memo_item["memo_id"]
      memo.content = memo_item["content"]
    end
  end

end
