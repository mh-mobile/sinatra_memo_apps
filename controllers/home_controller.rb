# frozen_string_literal: true

require "sinatra/base"
require_relative "app_controller.rb"

class HomeController < AppController
  get "/" do
    redirect "/memos"
  end

  get "/*" do
    erb :not_found
  end
end
