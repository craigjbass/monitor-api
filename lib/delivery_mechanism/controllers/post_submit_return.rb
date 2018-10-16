module DeliveryMechanism
  module Controllers
    class PostSubmitReturn
      def initialize(submit_return:, notify_project_members_of_submission:)
        @submit_return = submit_return
        @notify_project_members_of_submission = notify_project_members_of_submission
      end

      def execute(request, request_hash, response)
        @submit_return.execute(
          return_id: request_hash[:return_id].to_i
        )

        @notify_project_members_of_submission.execute(
          project_id: request_hash[:project_id].to_i,
          url: request_hash[:url]
        )

        response.status = 200
      end
    end
  end
end
