class UI::UseCase::UpdateReturn
  def initialize(update_return:, get_return:, convert_ui_hif_return:)
    @update_return = update_return
    @get_return = get_return
    @convert_ui_hif_return = convert_ui_hif_return
  end

  def execute(return_id:, return_data:)
    type = @get_return.execute(id: return_id)[:type]

    return_data = @convert_ui_hif_return.execute(return_data: return_data) if type == 'hif'

    @update_return.execute(return_id: return_id, return_data: return_data)

    {}
  end
end
