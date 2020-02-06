require_relative "controllers/memos_controller.rb"
require_relative "controllers/home_controller.rb"
require "sinatra"
require "sinatra/reloader"

run Rack::URLMap.new({
  "/" => HomeController,
  "/memos" => MemosController
})
