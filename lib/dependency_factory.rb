require 'dry/container'

class DependencyFactory
  attr_accessor :database

  def initialize
    @use_case_container = Dry::Container.new
    @gateway_container = Dry::Container.new

    setup_logger
  end

  def default_dependencies
    LocalAuthority::UseCases.register(self)
    LocalAuthority::Gateways.register(self)
    HomesEngland::UseCases.register(self)
    HomesEngland::Gateways.register(self)
    Common::UseCases.register(self)
    UI::UseCases.register(self)
    UI::Gateways.register(self)
  end

  def define_use_case(use_case, &block)
    @use_case_container.register(use_case) { block.call }
  end

  def define_gateway(gateway, &block)
    @gateway_container.register(gateway) { block.call }
  end

  def get_use_case(use_case)
    Common::Proxy::Logging.new(
      logger: @logger,
      use_case: @use_case_container.resolve(use_case)
    )
  end

  def get_gateway(gateway)
    @gateway_container.resolve(gateway)
  end

  def setup_logger
    return unless ENV['NO_LOGS'].nil?

    @logger = Logger.new(STDOUT)
  end
end
