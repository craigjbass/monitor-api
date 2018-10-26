require 'date'

class LocalAuthority::UseCase::CreateApiKey
  def execute(project_id:, email:)
    api_key = JWT.encode(
      { project_id: project_id, email: email, exp: thirty_days_from_now },
      ENV['HMAC_SECRET'],
      'HS512'
    )

    { api_key: api_key }
  end

  private

  def thirty_days_from_now
    current_time_in_seconds = DateTime.now.strftime('%s').to_i
    thirty_days_in_seconds = 60 * 60 * 24 * 30

    current_time_in_seconds + thirty_days_in_seconds
  end
end
