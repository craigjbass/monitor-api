# frozen_string_literal: true

class HomesEngland::Gateway::SequelProject
  def initialize(database:)
    @database = database
  end

  def create(project)
    @database[:projects].insert(
      type: project.type,
      data: Sequel.pg_json(project.data),
      status: project.status
    )
  end

  def find_by(id:)
    row = @database[:projects].where(id: id).first

    HomesEngland::Domain::Project.new.tap do |p|
      p.type = row[:type]
      p.data = Common::DeepSymbolizeKeys.to_symbolized_hash(row[:data].to_h)
      p.status = row[:status]
    end
  end

  def update(id:, project:)
    updated = @database[:projects]
              .where(id: id)
              .update(
                data: Sequel.pg_json(project.data),
                status: project.status
              )

    { success: updated.positive? }
  end

  def submit(id:)
    row = @database[:projects].where(id: id).first
    if row[:status] == 'Draft'
      @database[:projects].where(id: id).update(status: 'LA Draft')
    else
      @database[:projects].where(id: id).update(status: 'Submitted')
    end
  end
end
