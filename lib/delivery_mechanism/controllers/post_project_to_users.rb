module DeliveryMechanism
  module Controllers
    class PostProjectToUsers
      def initialize(add_user_to_project:)
        @add_user_to_project = add_user_to_project
      end

      def execute(params, request_hash, response)
        user_emails = request_hash[:users]

        return 400 unless user_emails.instance_of? Array
        cleaned_up_emails = user_emails.map(&:strip).reject(&:empty?)
        return 400 if user_emails.any? && cleaned_up_emails.empty?

        cleaned_up_emails.each do |email|
          @add_user_to_project.execute({ email: email, project_id: params[:id].to_i })
        end
        response.status = 200
        response
      end
    end
  end
end
