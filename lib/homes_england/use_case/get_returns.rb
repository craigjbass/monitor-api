class HomesEngland::UseCase::GetReturns
  def initialize(return_gateway:)
  end

  def execute(*)
    [{
      project_id: 1,
      data:
      {
        summary: {
          project_name: 'Cats Protection League',
          description: 'A new headquarters for all the Cats',
          lead_authority: 'Made Tech'
        },
        infrastructure: {
          type: 'Cat Bathroom',
          description: 'Bathroom for Cats',
          completion_date: '2018-12-25'
        },
        financial: {
          date: '2017-12-25',
          funded_through_HIF: true
        }
      }
    }]
  end
end
