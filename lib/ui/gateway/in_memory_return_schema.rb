# frozen_string_literal: true

class UI::Gateway::InMemoryReturnSchema
  def find_by(type:)
    return nil unless type == 'hif'
    
    schema = 'hif_return.json'

    create_template(schema)
  end

  private

  def create_template(schema)
    @template = Common::Domain::Template.new
    @template.schema = JSON.parse(
      File.open("#{__dir__}/schemas/#{schema}", 'r').read,
      symbolize_names: true
    )

    delete_s151_tab if ENV['S151_TAB'].nil?
    delete_confirmation_tab if ENV['CONFIRMATION_TAB'].nil?
    delete_outputs_forcast_tab if ENV['OUTPUTS_FORECAST_TAB'].nil?
    delete_outputs_actuals_tab if ENV['OUTPUTS_ACTUALS_TAB'].nil?
    delete_rm_monthly_catchup_tab if ENV['RM_MONTHLY_CATCHUP_TAB'].nil?

    @template
  end

  def delete_s151_tab
    @template.schema[:properties][:s151] = nil
  end

  def delete_confirmation_tab
    @template.schema[:properties][:s151Confirmation] = nil
  end

  def delete_outputs_forcast_tab
    @template.schema[:properties][:outputsForecast] = nil
  end

  def delete_outputs_actuals_tab
    @template.schema[:properties][:outputsActuals] = nil
  end

  def delete_rm_monthly_catchup_tab
    @template.schema[:properties][:rmMonthlyCatchup] = nil
  end
end
