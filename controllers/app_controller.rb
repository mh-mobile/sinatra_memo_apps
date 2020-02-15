# frozen_string_literal: true

require "sinatra/base"

class AppController < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  enable :method_override

  set :root, File.join(File.dirname(__FILE__), "..")
  set :views, Proc.new { File.join(root, "views") }
  set :show_exceptions, false

  def logger 
    @logger ||= begin
      file = File.new("#{settings.root}/log/#{settings.environment}.log", "a+")
      file.sync = true
      Logger.new(file)
    end
  end

  helpers do
    def h(text)
      Rack::Utils.escape_html(text)
    end

    def nl2br(text)
      h(text).gsub(/\R/, "<br>")
    end

    def first_line(text)
      h(text).split(/\R/)[0]
    end

    def truncate(text, max = 50)
      text = text[0, max] + "..." if text.length > max
      text
    end
  end

  not_found do
    erb :not_found
  end

  error 500 do
    logger.error(env["sinatra.error"].message)
    erb :system_error
  end
end
