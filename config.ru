# frozen_string_literal: true

require_relative "controllers/memos_controller.rb"
require_relative "controllers/home_controller.rb"
require "sinatra"

use Rack::Static, urls: ["/css"], root: "public"

run Rack::URLMap.new({
  "/" => HomeController,
  "/memos" => MemosController
})
