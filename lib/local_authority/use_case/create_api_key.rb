require 'date'

class LocalAuthority::UseCase::CreateApiKey
  def execute(project_id:)
    api_key = JWT.encode(
      { project_id: project_id, exp: four_hours_from_now },
      ENV['HMAC_SECRET'],
      'HS512'
    )

    { api_key: api_key }
  end

  private

  def four_hours_from_now
    current_time_in_seconds = DateTime.now.strftime('%s').to_i
    four_hours_in_seconds = 60 * 4

    current_time_in_seconds + four_hours_in_seconds
  end
end
