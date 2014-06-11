#!/usr/bin/env ruby
require 'thor'
require 'rest_client'
require 'json'
require 'pry'

class Todo < Thor
  desc "lists USERNAME", "get all the lists for USERNAME"
  def lists(username)
    # json = { params: {:user => {:username => username}}, accept: :json}.to_json
    # RestClient.get 'http://lvh.me:3000/api/lists', json
    response = RestClient.get "http://lvh.me:3000/api/lists?user[username]=#{username}"
    puts response
  end

  desc "create a list", "create a list for USERNAME"
  def create_list(username, list_name)
    credentials = { params: { user: { username: username}}} 
    json = credentials.merge({:list => {:name => list_name}}).to_json
    RestClient.post 'http://lvh.me:3000/api/list#create', json, content_type: :json, accept: :json
  end
end

Todo.start(ARGV)

