require 'sinatra'
require 'json'


tasks = Array.new

configure do
    enable :cross_origin
    raw = File.read('data.json')
    tasks = JSON.parse(raw)
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
    tasks.to_json
end


puts "Main finished"
