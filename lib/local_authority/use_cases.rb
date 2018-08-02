# frozen_string_literal: true

class LocalAuthority::UseCases
  def self.register(builder)
    builder.define_use_case :return_gateway do
      LocalAuthority::Gateway::SequelReturn.new(database: builder.database)
    end

    builder.define_use_case :return_template_gateway do
      LocalAuthority::Gateway::InMemoryReturnTemplate.new
    end

    builder.define_use_case :populate_return_template do
      LocalAuthority::UseCase::PopulateReturnTemplate.new(
        template_gateway: builder.get_use_case(:return_template_gateway)
      )
    end

    builder.define_use_case :get_base_return do
      LocalAuthority::UseCase::GetBaseReturn.new(
        populate_return: builder.get_use_case(:populate_return_template),
        project_gateway: builder.get_use_case(:project_gateway)
      )
    end

    builder.define_use_case :create_return do
      LocalAuthority::UseCase::CreateReturn.new(
        return_gateway: builder.get_use_case(:return_gateway)
      )
    end

    builder.define_use_case :get_return do
      LocalAuthority::UseCase::GetReturn.new(
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
        return_gateway: builder.get_use_case(:return_gateway)
      )
    end
  end
end
