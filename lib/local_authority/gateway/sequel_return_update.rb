class LocalAuthority::Gateway::SequelReturnUpdate
  def initialize(database:)
    @database = database
  end

  def create(return_update)
    @database[:return_updates].insert(
      return_id: return_update.return_id,
      data: Sequel.pg_json(return_update.data)
    )
  end

  def find_by(id:)
    row = @database[:return_updates].where(id: id).first
    row_to_return_update(row)
  end

  def updates_for(return_id:)
    @database[:return_updates].where(return_id: return_id).order(:id).map { |row| row_to_return_update(row) }
  end

  private

  def row_to_return_update(row)
    LocalAuthority::Domain::ReturnUpdate.new.tap do |r|
      r.return_id = row[:return_id]
      r.data = Common::DeepSymbolizeKeys.to_symbolized_hash(row[:data].to_h)
    end
  end
end
