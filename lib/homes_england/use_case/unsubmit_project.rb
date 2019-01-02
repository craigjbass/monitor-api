# frozen_string_literal: true

class HomesEngland::UseCase::UnSubmitProject
  def initialize(project_gateway:, return_gateway:)
    @project_gateway = project_gateway
    @return_gateway = return_gateway
  end

  def execute(project_id:)
    return if ENV['BACK_TO_BASELINE'].nil?

    project = @project_gateway.find_by(id: project_id)
    
    delete_returns(project_id)

    @project_gateway.submit(id: project_id, status: 'Draft')
  end

  private

  def delete_returns(project_id)
    returns = @return_gateway.get_returns(project_id: project_id)
    returns.each do |r|
      @return_gateway.delete(return_id: r.id)
    end
  end
end