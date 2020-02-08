require "sinatra/base"
require_relative "../models/memo.rb"

class Rack::MethodOverride
  ALLOWED_METHOD = %w[POST GET]
  def method_override(env)
    req = Rack::Request.new(env)
     method = req.params[METHOD_OVERRIDE_PARAM_KEY] || env[HTTP_METHOD_OVERRIDE_HEADER]
     method.to_s.upcase
  end
end


class MemosController < Sinatra::Base

  enable :method_override

  set :root, File.join(File.dirname(__FILE__), "..")
  set :views, Proc.new { File.join(root, "views") }

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

    def trancate(text, max=50) 
      text = text[0, max] + "..." if text.length > max
      text
    end
  end

  get "/" do 
    @memos = Memo.findAll
    @require_new_link = true
    erb :index
  end

  # create
  post "/" do
    memo = Memo.create(params["content"])
    if memo.nil?
      redirect "/memos"
    else
      redirect "/memos/#{memo.memo_id}"
    end
  end

  get "/new" do
    erb :new
  end

  # show 
  get "/:id" do |memo_id|
    @memo = Memo.find(memo_id.to_i)
    erb :show
  end

  # destroy
  delete "/:id" do |memo_id|
    Memo.delete(memo_id.to_i)
    redirect "/memos"
  end

  # update
  patch "/:id" do |memo_id|
    Memo.update(memo_id.to_i, params["content"])
    redirect "/memos/#{memo_id}"
  end

  # new
  # edit
  get "/:id/edit" do |memo_id|
    @memo = Memo.find(memo_id.to_i)
    erb :edit
  end

  not_found do
    erb :not_found
  end
end
