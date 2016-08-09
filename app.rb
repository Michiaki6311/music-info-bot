require 'sinatra'
require 'json'
require 'activerecord'
require 'sinatra/activerecord'

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || 'postgres://amfzhtdoyvixst:dyR7kstCVyDT6HCs3bY4cbGqAr@ec2-54-235-89-113.compute-1.amazonaws.com:5432/daeo4qlo2s0b9q')

class Count < ActiveRecord::Base; end

get '/' do
  'Hello,World!'
end

get '/music' do
  'Music information'
end

post '/music' do
end

