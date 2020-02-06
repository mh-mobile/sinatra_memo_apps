require "sinatra/base"
require_relative "../models/memo.rb"

class MemosController < Sinatra::Base

  set :root, File.join(File.dirname(__FILE__), "..")
  set :views, Proc.new { File.join(root, "views") }

  get "/" do 
    Memo.findAll
    erb :index
  end

  # show 
  get "/:id" do |memo_id|
    erb :show
  end

  # new
  get "/new" do
    erb :new
  end

  # edit
  get "/:id/edit" do |memo_id|
    erb :edit
  end

  # destroy
  delete "/:id" do |memo_id|
    Memo.delete(memo_id)
    redirect "/#{memo_id}"
  end

  # update
  patch "m/:id" do |memo_id|
    memos_controller.update
  end

  # create
  post "/" do
    content = ""
    Memo.create(content)
    redirect "/memos"
  end

  not_found do
    erb :not_found
  end
end
