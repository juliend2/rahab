require './application.rb'

run Rack::URLMap.new({
  "/" => Application.new,
  "/password" => Password.new
  # TODO: add a route (protected) to reset the $master_password in case we
  # entered a wrong one that doesn't work to decrypt our passwords
})
