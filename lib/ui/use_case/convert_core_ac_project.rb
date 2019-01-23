# frozen_string_literal: true

class UI::UseCase::ConvertCoreACProject
  def execute(project_data:)
    @project_data = project_data
    @converted_project = {}

    convert_summary
    convert_conditions
    convert_financials
    convert_milestones
    convert_outputs

    @converted_project
  end

  private

  def convert_summary
    return if @project_data[:summary].nil?
    @converted_project[:summary] = @project_data[:summary]
  end

  def convert_conditions
    return if @project_data[:conditions].nil?
    @converted_project[:conditions] = @project_data[:conditions]
  end

  def convert_financials
    return if @project_data[:financials].nil?
    @converted_project[:financials] = @project_data[:financials]
  end

  def convert_milestones
    return if @project_data[:milestones].nil?
    @converted_project[:milestones] = @project_data[:milestones]
  end

  def convert_outputs
    return if @project_data[:outputs].nil?
    @converted_project[:outputs] = @project_data[:outputs]
  end
end