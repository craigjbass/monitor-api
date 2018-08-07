# frozen_string_literal: true

class LocalAuthority::UseCase::GetBaseReturn
  def initialize(return_gateway:, project_gateway:, populate_return_template:)
    @return_gateway = return_gateway
    @project_gateway = project_gateway
    @populate_return_template = populate_return_template
  end

  def execute(project_id:)
    project = @project_gateway.find_by(id: project_id)
    schema = @return_gateway.find_by(type: project.type)

    if project.type == 'hif'
      #Take in some baseline project data and return that hash, unknowns can be nil

      return_template_populator = @populate_return_template
      return_template_populator.execute(type: 'hif', data: project.data)
    end

    #base_return populated with relevent data from the baseline
    #Return might have new fields but will also want to see original from base
    #Pull the relevent stuff (just targetSubmission) from the baseline project ^, stuff I don't have in baseline can be nil
    { base_return: { id: project_id, data: project.data, schema: schema.schema } }
  end
end
