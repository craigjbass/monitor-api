class LocalAuthority::Gateway::InMemoryAccessTokenGateway
  @@access_token = []

  def create(access_token)
    @@access_token << access_token
  end

  def find_by(uuid:)
    @@access_token.find {|token| token.uuid == uuid}
  end

  def delete(uuid:)
    @@access_token.delete_if {|token| token.uuid == uuid}
  end

  def clear
    @@access_token = []
  end
end
