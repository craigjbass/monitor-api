class Common::Proxy::Logging
  def initialize(logger:, use_case:)
    @logger = logger
    @use_case = use_case
  end

  def execute(request)
    @logger&.info(
      {
        message_type: 'before-use-case-called',
        name: @use_case.class.name,
        request: request
      }.inspect
    )

    response = @use_case.execute(request)

    @logger&.info(
      {
        message_type: 'after-use-case-called',
        name: @use_case.class.name,
        request: request,
        response: response
      }.inspect
    )

    response
  end
end
