class LocalAuthority::Gateway::InMemoryAccessTokenGateway
  @@access_token = []

  def save(access_token:)
    @@access_token << access_token
  end

  def find_by(access_token:)
    @@access_token.index(access_token)
  end

  def delete(access_token:)
    @@access_token.delete(access_token)
  end

  def clear
    @@access_token = []
  end
end
