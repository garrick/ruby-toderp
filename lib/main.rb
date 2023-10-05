require 'sinatra'
require 'json'
require 'singleton'

class FakeDB
  attr_accessor :tasks
  include Singleton
  def initialize
    raw = File.read('data.json')
    @tasks = JSON.parse(raw)
  end
end

configure do
    enable :cross_origin
end

before do
    response.headers['Access-Control-Allow-Origin'] = '*'
end

options "*" do
    response.headers["Allow"] = "GET, PUT, POST, DELETE, OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token"
    response.headers["Access-Control-Allow-Origin"] = "*"
    200
end

get '/' do
    'Welcome to the TO-DERP List!'
end

get '/tasks' do
    content_type :json
    FakeDB.instance.tasks.to_json
end

# curl -X POST http://localhost:4567/tasks/add -H 'Content-Type: application/json' -d '{"task":{"title":"Work harder","done":false}}'
post '/tasks/add' do
    payload = JSON.parse(request.body.read)
    FakeDB.instance.tasks << payload
    write_out 
end

def write_out
    File.write('data.json', JSON.dump(FakeDB.instance.tasks))
end


puts "Main finished"
