module DeliveryMechanism
  module Controllers 
    class PostSubmitReturn
      def initialize(submit_return:, notify_project_members:)
        @submit_return = submit_return
        @notify_project_members = notify_project_members
      end

      def execute(request, request_hash, response)
        @submit_return.execute(
          return_id: request_hash[:return_id].to_i
        )

        @notify_project_members.execute(
          project_id: request_hash[:project_id].to_i,
          url: request_hash[:url]
        )

        response.status = 200
      end
    end
  end
end