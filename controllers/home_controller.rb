# frozen_string_literal: true

require "sinatra/base"

class HomeController < Sinatra::Base
  get "/" do
    redirect "/memos"
  end
end
