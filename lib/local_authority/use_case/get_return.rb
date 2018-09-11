# frozen_string_literal: true

class LocalAuthority::UseCase::GetReturn
  def initialize(return_gateway:,return_update_gateway:, calculate_return:, get_returns:)
    @return_gateway = return_gateway
    @return_update_gateway = return_update_gateway
    @calculate_return = calculate_return
    @get_returns = get_returns
  end

  def execute(id:)
    found_return = @return_gateway.find_by(id: id)
    project_id = found_return.project_id
    updates = @return_update_gateway.updates_for(return_id: id)


    previous_return = @get_returns.execute(project_id: project_id)[:returns].select do |return_data|
      return_data[:id] < found_return.id && return_data[:status] == 'Submitted'
    end

    previous_return_data = previous_return.dig(-1, :updates, -1)

    updates[-1]&.data = @calculate_return.execute(return_data_with_no_calculations: updates[-1]&.data, previous_return: previous_return_data)[:calculated_return]


    if found_return.nil?
      {}
    else
      {
        id: found_return.id,
        project_id: found_return.project_id,
        status: found_return.status,
        updates: updates.map(&:data)
      }
    end
  end
end
