# frozen_string_literal: true

class HomesEngland::UseCase::PopulateTemplate
  def initialize(template_gateway:)
    @template_gateway = template_gateway
  end

  def execute(type:, baseline:)
    template = @template_gateway.get_template(type: type)
    populated_data = populate_hash(template.layout.dup, baseline)
    {
      populated_data: populated_data
    }
  end

  private

  def populate_hash(base, data)
    base.each do |key, value|
      next if data[key].nil?
      base[key] = get_data_value(base, data, key, value)
    end
  end

  def get_data_value(base, data, key, value)
    case base[key]
    when Hash
      populate_hash(value, data[key])
    else
      data[key]
    end
  end
end
