class UI::UseCase::UpdateReturn
  def initialize(update_return:)
    @update_return = update_return
  end

  def execute(return_id:, return_data:)
    @update_return.execute(return_id: return_id, return_data: return_data)

    {}
  end
end
