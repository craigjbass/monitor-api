# frozen_string_literal: true

Sequel.migration do
  up do
    projects = from(:projects)

    projects.each do |project|
      project[:data]['summary']['totalArea'] = project[:data]['summary']['totalArea'].to_s
      project[:data]['summary']['hifFundingAmount'] = project[:data]['summary']['hifFundingAmount'].to_s
      project[:data]['summary']['noOfHousingSites'] = project[:data]['summary']['noOfHousingSites'].to_s
      project[:data]['outputsForecast']['totalUnits'] = project[:data]['outputsForecast']['totalUnits'].to_s
      project[:data]['infrastructures'].each_with_index do |_infra, i|
        project[:data]['infrastructures'][i]['landOwnership']['howManySitesToAcquire'] = project[:data]['infrastructures'][i]['landOwnership']['howManySitesToAcquire'].to_s
      end

      from(:projects).where(id: project[:id]).update(data: project[:data])
    end
  end

  down do
  end
end
