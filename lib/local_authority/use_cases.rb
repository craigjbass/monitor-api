# frozen_string_literal: true

class LocalAuthority::UseCases
  def self.register(builder)
    builder.define_use_case :return_gateway do
      LocalAuthority::Gateway::SequelReturn.new(database: builder.database)
    end

    builder.define_use_case :return_update_gateway do
      LocalAuthority::Gateway::SequelReturnUpdate.new(
        database: builder.database
      )
    end

    builder.define_use_case :return_template_gateway do
      LocalAuthority::Gateway::InMemoryReturnTemplate.new
    end

    builder.define_use_case :users_gateway do
      LocalAuthority::Gateway::SequelUsers.new(
        database: builder.database
      )
    end

    builder.define_use_case :access_token_gateway do
      LocalAuthority::Gateway::InMemoryAccessTokenGateway.new
    end

    builder.define_use_case :notification_gateway do
      LocalAuthority::Gateway::GovEmailNotificationGateway.new
    end

    builder.define_use_case :api_key_gateway do
      LocalAuthority::Gateway::InMemoryAPIKeyGateway.new
    end


    builder.define_use_case :find_path_data do
      LocalAuthority::UseCase::FindPathData.new
    end

    builder.define_use_case :get_schema_copy_paths do
      LocalAuthority::UseCase::GetSchemaCopyPaths.new(
        template_gateway: builder.get_use_case(:return_template_gateway)
      )
    end

    builder.define_use_case :populate_return_template do
      LocalAuthority::UseCase::PopulateReturnTemplate.new(
        template_gateway: builder.get_use_case(:return_template_gateway),
        find_path_data: builder.get_use_case(:find_path_data),
        get_schema_copy_paths: builder.get_use_case(:get_schema_copy_paths)
      )
    end

    builder.define_use_case :get_base_return do
      LocalAuthority::UseCase::GetBaseReturn.new(
        return_gateway: builder.get_use_case(:return_template_gateway),
        project_gateway: builder.get_use_case(:project_gateway),
        populate_return_template: builder.get_use_case(:populate_return_template),
        get_returns: builder.get_use_case(:get_returns)
      )
    end

    builder.define_use_case :create_return do
      LocalAuthority::UseCase::CreateReturn.new(
        return_gateway: builder.get_use_case(:return_gateway),
        return_update_gateway: builder.get_use_case(:return_update_gateway)
      )
    end

    builder.define_use_case :update_return do
      LocalAuthority::UseCase::UpdateReturn.new(
        return_gateway: builder.get_use_case(:return_gateway)
      )
    end

    builder.define_use_case :soft_update_return do
      LocalAuthority::UseCase::SoftUpdateReturn.new(
        return_update_gateway: builder.get_use_case(:return_update_gateway)
      )
    end

    builder.define_use_case :get_return do
      LocalAuthority::UseCase::GetReturn.new(
        return_gateway: builder.get_use_case(:return_gateway),
        return_update_gateway: builder.get_use_case(:return_update_gateway),
        calculate_return: builder.get_use_case(:calculate_hif_return),
        get_returns: builder.get_use_case(:get_returns)
      )
    end

    builder.define_use_case :submit_return do
      LocalAuthority::UseCase::SubmitReturn.new(
        return_gateway: builder.get_use_case(:return_gateway)
      )
    end

    builder.define_use_case :get_schema_for_return do
      LocalAuthority::UseCase::GetSchemaForReturn.new(
        project_gateway: builder.get_use_case(:project_gateway),
        return_gateway: builder.get_use_case(:return_gateway),
        template_gateway: builder.get_use_case(:return_template_gateway)
      )
    end

    builder.define_use_case :get_returns do
      LocalAuthority::UseCase::GetReturns.new(
        return_gateway: builder.get_use_case(:return_gateway),
        return_update_gateway: builder.get_use_case(:return_update_gateway)
      )
    end

    builder.define_use_case :check_email do
      LocalAuthority::UseCase::CheckEmail.new(
        users_gateway: builder.get_use_case(:users_gateway)
      )
    end

    builder.define_use_case :create_access_token do
      LocalAuthority::UseCase::CreateAccessToken.new(
        access_token_gateway: builder.get_use_case(
          :access_token_gateway
        )
      )
    end

    builder.define_use_case :expend_access_token do
      LocalAuthority::UseCase::ExpendAccessToken.new(
        access_token_gateway: builder.get_use_case(
          :access_token_gateway
        ),create_api_key: builder.get_use_case(:create_api_key)
      )
    end

    builder.define_use_case :create_api_key do
      LocalAuthority::UseCase::CreateApiKey.new
    end

    builder.define_use_case :send_notification do
      LocalAuthority::UseCase::SendNotification.new(
        notification_gateway: builder.get_use_case(:notification_gateway)
      )
    end

    builder.define_use_case :check_api_key do
      LocalAuthority::UseCase::CheckApiKey.new
    end

    builder.define_use_case :calculate_hif_return do
      LocalAuthority::UseCase::CalculateHIFReturn.new
    end
  end
end
