class LocalAuthority::Gateway::InMemoryEmailWhitelistGateway

  def initialize()
    @whitelist = ENV.fetch('EMAIL_WHITELIST').split(':')
  end

  def find_by(email)
    @whitelist.index(email)
  end
end
