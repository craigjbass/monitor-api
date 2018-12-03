# frozen_string_literal: true

class HomesEngland::Gateway::SequelProject
  def initialize(database:)
    @database = database
  end

  def create(project)
    @database[:projects].insert(
      name: project.name,
      type: project.type,
      data: Sequel.pg_json(project.data),
      status: project.status
    )
  end

  def find_by(id:)
    row = @database[:projects].where(id: id).first

    HomesEngland::Domain::Project.new.tap do |p|
      p.name = row[:name]
      p.type = row[:type]
      p.data = Common::DeepSymbolizeKeys.to_symbolized_hash(row[:data].to_h)
      p.status = row[:status]
      p.timestamp = row[:timestamp]
    end
  end

  def update(id:, project:)
    updated = @database[:projects]
              .where(id: id)
              .update(
                name: project.name,
                data: Sequel.pg_json(project.data),
                status: project.status,
                timestamp: project.timestamp
              )

    { success: updated.positive? }
  end

  def submit(id:, status:)
    @database[:projects].where(id: id).update(status: status)
  end
end
