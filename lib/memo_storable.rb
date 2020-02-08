# frozen_string_literal: true

module MemoStorable
  def store_strategy(store)
    @store = store
  end

  def findAll
    @store.findAll
  end

  def find(memo_id)
    @store.find(memo_id)
  end

  def delete(memo_id)
    @store.delete(memo_id)
  end

  def update(memo_id, content)
    @store.update(memo_id, content)
  end

  def create(content)
    @store.create(content)
  end
end
