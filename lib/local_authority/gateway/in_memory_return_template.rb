# frozen_string_literal: true

# noinspection RubyScope
class LocalAuthority::Gateway::InMemoryReturnTemplate
  def initialize(hif_returns_schema:, ac_returns_schema:)
    @hif_returns_schema = hif_returns_schema
    @ac_returns_schema = ac_returns_schema
  end

  def find_by(type:)
    return @hif_returns_schema.execute if type == 'hif'
    return @ac_returns_schema.execute if type == 'ac'
    nil
  end
end
