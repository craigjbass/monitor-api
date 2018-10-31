# frozen_string_literal: true

class UI::UseCases
  def self.register(builder)
    builder.define_use_case :ui_create_project do
      UI::UseCase::CreateProject.new(
        create_project: builder.get_use_case(:create_new_project)
      )
    end

    builder.define_use_case :ui_get_project do
      UI::UseCase::GetProject.new(
        find_project: builder.get_use_case(:find_project)
      )
    end

    builder.define_use_case :ui_update_project do
      UI::UseCase::UpdateProject.new(
        update_project: builder.get_use_case(:update_project)
      )
    end

    builder.define_use_case :ui_get_base_return do
      UI::UseCase::GetBaseReturn.new(
        get_base_return: builder.get_use_case(:get_base_return)
      )
    end

    builder.define_use_case :ui_create_return do
      UI::UseCase::CreateReturn.new(
        create_return: builder.get_use_case(:create_return)
      )
    end

    builder.define_use_case :ui_update_return do
      UI::UseCase::UpdateReturn.new(
        update_return: builder.get_use_case(:soft_update_return)
      )
    end

    builder.define_use_case :ui_get_return do
      UI::UseCase::GetReturn.new(
        get_return: builder.get_use_case(:get_return)
      )
    end
  end
end
