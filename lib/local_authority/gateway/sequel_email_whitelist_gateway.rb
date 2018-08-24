class LocalAuthority::Gateway::SequelEmailWhitelistGateway
  def initialize(database:)
    @database = database
  end

  def find_by(email)
    user = @database[:users].first(email: email)
    return nil if user.nil?

    LocalAuthority::Domain::User.new.tap do |u|
      u.id = user[:id]
      u.projects = []
      u.projects = user[:projects] unless user[:projects].nil?
    end
  end

  def create(email, projects = [])
    if projects.empty?
      @database[:users].insert(
        email: email
      )
    else
      @database[:users].insert(
        email: email,
        projects: Sequel.pg_array(projects)
      )
    end
  end
end
