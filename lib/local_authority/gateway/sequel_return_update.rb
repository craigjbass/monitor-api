class LocalAuthority::Gateway::SequelReturn
  def soft_update(return_id:, return_data:, status:)
    @database[:return_updates].insert(
      return_id: return_id,
      data: Sequel.pg_json(return_data)
    )
  end
end
