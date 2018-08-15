class LocalAuthority::Gateway::InMemoryGUIDGateway
  @@guid_list = []

  def save(guid:)
    @@guid_list << guid
  end

  def find_by(guid:)
    @@guid_list.index(guid)
  end

  def delete(guid:)
    @@guid_list.delete(guid)
  end

  def clear
    @@guid_list = []
  end
end
