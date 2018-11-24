require 'pg'
require './application.rb'

use Rack::Static, 
    :urls => ["/images", "/js", "/css"],
    :root => "public"

run Rack::URLMap.new({
  "/" => Application.new,
  "/password" => Password.new,
  "/logout" => Logout.new,
})
