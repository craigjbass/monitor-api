class LocalAuthority::Gateway::SequelEmailWhitelistGateway

  def initialize()
    @whitelist = ENV.fetch('EMAIL_WHITELIST').split(':')
  end

  def find_by(email)
    @whitelist.index(email)
  end

  def add(email)
    @whitelist << email
  end
end
