# frozen_string_literal: true

Sequel.migration do
  up do
    alter_table(:projects) do
      add_column :name, String, default: 'Untitled Project'
    end

    from(:projects).each do |project|
      project_name = project.dig(:data, 'summary','projectName')
      from(:projects).where(id: project[:id]).update(name: project_name) unless project_name.nil?
    end
  end

  down do
    alter_table(:projects) do
      drop_column :name
    end
  end
end
