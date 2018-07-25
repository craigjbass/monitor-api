class HomesEngland::Gateway::SequelProject
  def initialize(database:)
    @database = database
  end

  def create(project)
    @database[:projects].insert(
      type: project.type,
      data: Sequel.pg_json(project.data)
    )
  end

  def find_by(id:)
    row = @database[:projects].where(id: id).first

    HomesEngland::Domain::Project.new.tap do |p|
      p.type = row[:type]
      p.data = Common::DeepSymbolizeKeys.to_symbolized_hash(row[:data].to_h)
    end
  end

  def update(id:, project:)
    updated = @database[:projects]
      .where(id: id)
      .update(
        type: project.type,
        data: Sequel.pg_json(project.data)
      )

    { success: updated > 0 }
  end
end

