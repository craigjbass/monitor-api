class LocalAuthority::Gateway::SequelReturn
  def initialize(database: database)
    @database = database
  end

  def create(new_return)
    @database[:returns].insert(
      project_id: new_return.project_id,
      data: Sequel.pg_json(new_return.data),
      status: new_return.status
    )
  end

  def find_by(id:)
    row = @database[:returns].where(id: id).first
    LocalAuthority::Domain::Return.new.tap do |r|
      r.project_id = row[:project_id]
      r.data = Common::DeepSymbolizeKeys.to_symbolized_hash(row[:data].to_h)
      r.status = row[:status]
    end
  end

  def get_returns(project_id:)
    @database[:returns].where(project_id: project_id).all.map do |db_r|
      LocalAuthority::Domain::Return.new.tap do |r|
        r.id = db_r[:id]
        r.project_id = db_r[:project_id]
        r.data = Common::DeepSymbolizeKeys.to_symbolized_hash(db_r[:data].to_h)
        r.status = db_r[:status]
      end
    end
  end

  # Hard update. To add soft update later.
  def update(return_id:, data:)
    @database[:returns].where(id: return_id).update(:data => Sequel.pg_json(data[:data]))
  end

  def submit(return_id: )
    @database[:returns].where(id: return_id).update(:status => 'Submitted')
  end
end
