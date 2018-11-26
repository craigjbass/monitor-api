class UI::UseCase::GetSchemaForReturn
  def initialize(get_return:, return_template:)
    @get_return = get_return
    @return_template = return_template
  end

  def execute(return_id:)
    type = @get_return.execute(id: return_id)[:type]
    schema = @return_template.find_by(type: type).schema
    {
      schema: schema
    }
  end
end