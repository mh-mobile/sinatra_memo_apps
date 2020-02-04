class MemoFileStore

  def findAll
    "call findAll"
  end

  def find(memo_id)
    "call find: #{memo_id}"
  end

  def delete(memo_id)
    "call delete: #{memo_id}"
  end

  def update(content)
    "call findAll: #{content}"
  end

  def create(content)
    "call create: #{content}"
  end
    
end
