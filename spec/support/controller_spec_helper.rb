module ControllerSpecHelper
  def json
    JSON.parse(response.body)
  end
end
