require "sinatra"
require "sinatra/reloader"
require_relative "controller/memos_controller.rb"


memos_controller = MemosController.new

# index
get "/" do 
  redirect "/memos"
end

get "/memos" do 
  memos_controller.index
end

# show 
get "/memos/:id" do |memo_id|
  memos_controller.show
end

# new
get "/memos/new" do
  memos_controller.new
end

# edit
get "/memos/:id/edit" do |memo_id|
  memos_controller.edit
end

# destroy
delete "memos/:id" do |memo_id|
  memos_controller.destroy
end

# update
patch "memos/:id" do |memo_id|
  memos_controller.update
end

# create
post "memos" do
  memos_controller.create
end

