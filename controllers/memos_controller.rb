# frozen_string_literal: true

require "sinatra/base"
require "sinatra/reloader"
require_relative "../models/memo.rb"

class MemosController < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

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

    def truncate(text, max = 50)
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
    redirect "/memos/new" if params["content"].empty?

    memo_id = Memo.create(params["content"])
    if memo_id.nil?
      redirect "/memos"
    else
      redirect "/memos/#{memo_id}"
    end
  end

  # new
  get "/new" do
    erb :new
  end

  # show
  get "/:id" do |memo_id|
    @memo = Memo.find(memo_id.to_i)
    if @memo.nil?
      erb :not_found
    else
      erb :show
    end
  end

  # destroy
  delete "/:id" do |memo_id|
    Memo.delete(memo_id.to_i)
    redirect "/memos"
  end

  # update
  patch "/:id" do |memo_id|
    redirect "/memos/#{memo_id}/edit" if params["content"].empty?
    Memo.update(memo_id.to_i, params["content"])
    redirect "/memos/#{memo_id}"
  end

  # edit
  get "/:id/edit" do |memo_id|
    @memo = Memo.find(memo_id.to_i)
    erb :edit
  end

  not_found do
    erb :not_found
  end
end
