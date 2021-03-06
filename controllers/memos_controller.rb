# frozen_string_literal: true

require "sinatra/base"
require "sinatra/reloader"
require_relative "app_controller.rb"
require_relative "../models/memo.rb"

class MemosController < AppController
  get "/" do
    @memos = Memo.find_all
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
end
