require 'dry/container'

class UseCaseFactory
  def initialize
    @container = Dry::Container.new
  end

  def default_dependencies
    HomesEngland::UseCases.register(self)
  end

  def define_use_case(use_case, &block)
    @container.register(use_case) { block.call }
  end

  def get_use_case(use_case)
    @container.resolve(use_case)
  end
end
