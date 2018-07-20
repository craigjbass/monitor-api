# frozen_string_literal: true

require 'json'

class HomesEngland::Gateway::FileProject
  def initialize(file_path:)
    @file_path = file_path
  end

  def create(project)
    projects = saved_projects

    projects << {
      type: project.type,
      data: project.data
    }

    write_projects(projects)

    projects.length - 1
  end

  def update(id:, project:)
    { success: false } if project_exists(id, project)

    projects = saved_projects
    projects[id] = {
      type: project[:type],
      data: project[:baseline]
    }

    write_projects(projects)

    { success: true }
  end

  def find_by(id:)
    return nil unless saved_projects[id]

    project_data = saved_projects[id]

    project = HomesEngland::Domain::Project.new
    project.type = project_data['type']
    project.data = Common::DeepSymbolizeKeys.to_symbolized_hash(
      project_data['data']
    )
    project
  end

  private

  def write_projects(projects)
    File.open(@file_path, 'w') do |f|
      f.write(projects.to_json)
    end
  end

  def project_exists(id, project)
    id.nil? || project.nil? || saved_projects.nil? || saved_projects[id].nil?
  end

  def saved_projects
    project_data = []

    File.open(@file_path, 'r') do |f|
      data = f.read
      project_data = JSON.parse(data) unless data == ''
    end

    project_data
  rescue Errno::ENOENT
    []
  end
end
