# frozen_string_literal: true

class UI::UseCases
  def self.register(builder)
    builder.define_use_case :convert_core_hif_project do
      UI::UseCase::ConvertCoreHIFProject.new
    end

    builder.define_use_case :convert_ui_hif_project do
      UI::UseCase::ConvertUIHIFProject.new
    end

    builder.define_use_case :convert_core_hif_return do
      UI::UseCase::ConvertCoreHIFReturn.new
    end

    builder.define_use_case :convert_ui_hif_return do
      UI::UseCase::ConvertUIHIFReturn.new
    end

    builder.define_use_case :ui_create_project do
      UI::UseCase::CreateProject.new(
        create_project: builder.get_use_case(:create_new_project),
        convert_ui_hif_project: builder.get_use_case(:convert_ui_hif_project)
      )
    end

    builder.define_use_case :ui_get_project do
      UI::UseCase::GetProject.new(
        find_project: builder.get_use_case(:find_project),
        convert_core_hif_project: builder.get_use_case(:convert_core_hif_project),
        project_schema_gateway: builder.get_gateway(:ui_project_schema)
      )
    end

    builder.define_use_case :ui_update_project do
      UI::UseCase::UpdateProject.new(
        update_project: builder.get_use_case(:update_project),
        convert_ui_hif_project: builder.get_use_case(:convert_ui_hif_project)
      )
    end

    builder.define_use_case :ui_validate_project do
      UI::UseCase::ValidateProject.new(
        project_schema_gateway: builder.get_gateway(:ui_project_schema),
        get_project_template_path_titles: builder.get_use_case(:get_template_path_titles)
      )
    end

    builder.define_use_case :ui_validate_return do 
      UI::UseCase::ValidateReturn.new(
        return_template_gateway: builder.get_gateway(:ui_return_schema),
        get_return_template_path_titles: builder.get_use_case(:get_template_path_titles)
      )
    end

    builder.define_use_case :ui_get_base_return do
      UI::UseCase::GetBaseReturn.new(
        get_base_return: builder.get_use_case(:get_base_return),
        find_project: builder.get_use_case(:find_project),
        convert_core_hif_return: builder.get_use_case(:convert_core_hif_return)
      )
    end

    builder.define_use_case :ui_create_return do
      UI::UseCase::CreateReturn.new(
        create_return: builder.get_use_case(:create_return),
        find_project: builder.get_use_case(:find_project),
        convert_ui_hif_return: builder.get_use_case(:convert_ui_hif_return)
      )
    end

    builder.define_use_case :ui_update_return do
      UI::UseCase::UpdateReturn.new(
        update_return: builder.get_use_case(:soft_update_return),
        get_return: builder.get_use_case(:get_return),
        convert_ui_hif_return: builder.get_use_case(:convert_ui_hif_return)
      )
    end

    builder.define_use_case :ui_get_return do
      UI::UseCase::GetReturn.new(
        get_return: builder.get_use_case(:get_return),
        convert_core_hif_return: builder.get_use_case(:convert_core_hif_return)
      )
    end

    builder.define_use_case :ui_get_schema_for_return do
      UI::UseCase::GetSchemaForReturn.new(
        get_return: builder.get_use_case(:ui_get_return),
        return_template: builder.get_gateway(:ui_return_schema)
      )
    end

    builder.define_use_case :ui_get_returns do
      UI::UseCase::GetReturns.new(
        get_returns: builder.get_use_case(:get_returns),
        find_project: builder.get_use_case(:find_project),
        convert_core_hif_return: builder.get_use_case(:convert_core_hif_return)
      )
    end
  end
end
