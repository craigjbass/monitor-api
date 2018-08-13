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

    builder.define_use_case :find_baseline_path do
      LocalAuthority::UseCase::FindBaselinePath.new()
    end

    builder.define_use_case :get_schema_copy_paths do
      LocalAuthority::UseCase::GetSchemaCopyPaths.new()
    end

    builder.define_use_case :populate_return_template do
      LocalAuthority::UseCase::PopulateReturnTemplate.new(
        template_gateway: builder.get_use_case(:return_template_gateway),
        find_baseline_path: builder.get_use_case(:find_baseline_path),
        get_schema_copy_paths: builder.get_use_case(:get_schema_copy_paths)
      )
    end

    builder.define_use_case :get_base_return do
      LocalAuthority::UseCase::GetBaseReturn.new(
        return_gateway: builder.get_use_case(:return_template_gateway),
        project_gateway: builder.get_use_case(:project_gateway),
        populate_return_template: builder.get_use_case(:populate_return_template)
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
        return_update_gateway: builder.get_use_case(:return_update_gateway)
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
  end
end
