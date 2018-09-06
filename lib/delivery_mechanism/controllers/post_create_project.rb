module DeliveryMechanism
  module Controllers
    class PostCreateProject
      def initialize(create_new_project:)
        @create_new_project = create_new_project
      end

      def execute(params, request_hash, response)
        id = @create_new_project.execute(
          type: request_hash[:type],
          baseline: Common::DeepSymbolizeKeys.to_symbolized_hash(request_hash[:baselineData])
        )

        response.body = {
          projectId: id
        }.to_json
        response.status = 201
      end
    end
  end
end
