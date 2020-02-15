# frozen_string_literal: true

require "sinatra/base"
require "sinatra/reloader"
require_relative "app_controller.rb"
require_relative "../models/memo.rb"

class MemosController < AppController
  get "/" do
    @memos = Memo.findAll
    @require_new_link = true
    logger.info("findAll called")
    erb :index
  end

  # create
  post "/" do
    redirect "/memos/new" if params["content"].empty?

    memo = Memo.create(params["content"])
    if memo.nil?
      logger.info("memo not created.")
      redirect "/memos"
    else
      logger.info("memo_id: #{memo.memo_id} created.")
      redirect "/memos/#{memo.memo_id}"
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
      logger.info("memo_id: #{memo_id} not found.")
      erb :not_found
    else
      logger.info("memo_id: #{memo_id} found.")
      erb :show
    end
  end

  # destroy
  delete "/:id" do |memo_id|
    Memo.delete(memo_id.to_i)
    logger.info("memo_id: #{memo_id} deleted.")
    redirect "/memos"
  end

  # update
  patch "/:id" do |memo_id|
    redirect "/memos/#{memo_id}/edit" if params["content"].empty?
    Memo.update(memo_id.to_i, params["content"])
    logger.info("memo_id: #{memo_id} updated.")
    redirect "/memos/#{memo_id}"
  end

  # edit
  get "/:id/edit" do |memo_id|
    @memo = Memo.find(memo_id.to_i)
    erb :edit
  end
end
