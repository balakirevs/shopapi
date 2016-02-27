class OrderProductSerializer < ActiveModel::Serializer
  cached

  def include_user?
    false
  end

  def cache_key
    [object, scope]
  end
end
