class UI::UseCase::CreateProject
  def initialize(create_project:)
    @create_project = create_project
  end

  def execute(type:, name:, baseline:)
    created_id = @create_project.execute(
      type: type, 
      name: name, 
      baseline: baseline
    )[:id]

    { id: created_id }
  end
end

