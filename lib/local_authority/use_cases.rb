# frozen_string_literal: true

class LocalAuthority::UseCases
  def self.register(builder)
    builder.define_use_case :return_gateway do
       LocalAuthority::Gateway::InMemoryReturnGateway.new
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
  end
end
