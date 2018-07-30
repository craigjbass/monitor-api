class LocalAuthority::Gateway::InMemoryReturnGateway
  @@return_data = []
  def initialize()

  end

  def create(return_object)
    @@return_data << return_object
    @@return_data.length - 1
  end

  def get_return(id:)
    if id <= @@return_data.length-1
      @@return_data[id]
    else
      nil
    end
  end
end
