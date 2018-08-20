class LocalAuthority::Gateway::InMemoryAPIKeyGateway
  @@api_keys = []

  def save(api_key:)
    @@api_keys << api_key
  end

  def find_by(api_key:)
    @@api_keys.index(api_key)
  end

  def delete(api_key:)
    @@api_keys.delete(api_key)
  end

  def clear
    @@api_keys = []
  end
end
