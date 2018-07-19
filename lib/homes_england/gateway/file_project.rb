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

    File.open(@file_path, 'w') do |f|
      f.write(projects.to_json)
    end

    projects.length - 1
  end

  def update(id:, project:)
    if id.nil? || project.nil? || saved_projects.nil? || saved_projects[id].nil?
      { success: 'false' }
    end
    projects = saved_projects
    projects[id] = {
      type: project[:type],
      data: project[:baseline]
    }
    File.open(@file_path, 'w') do |f|
      f.write(projects.to_json)
    end
    { success: 'true' }
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

  def deep_symbolize_keys(obj)
    case obj
    when Hash
      result = {}
      obj.each do |key, value|
        result[key.to_sym] = deep_symbolize_keys(value)
      end
      result
    when Array
      obj.map { |value| deep_symbolize_keys(value) }
    else
      obj
    end
  end
end
