require 'sinatra'
require 'json'
require 'active_record'
require 'sinatra/activerecord'

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || 'postgres://amfzhtdoyvixst:dyR7kstCVyDT6HCs3bY4cbGqAr@ec2-54-235-89-113.compute-1.amazonaws.com:5432/daeo4qlo2s0b9q')

class Item < ActiveRecord::Base; end

get '/' do
  'Hello,World!'
end

get '/music' do
  @title = "Music Information"
  erb :index
end

post '/music' do
  music = Item.new
  music.title  = params[:title]
  music.artist = params[:artist]
  music.genre  = params[:genre]
  music.url    = params[:url]
  music.save
  redirect '/'
end

get '/show' do
  @title = "Music Information List"
  @items = Item.all
  erb :show
end

post '/lingr' do
  j = JSON.parse(request.body.string)
  j['events'].select{|e| e['message']}.map{|e|
    if e['message']['text'] == "#music" then
      Item.order('RANDOM()').limit(1).first.url
      else
        ""
    end
  }
end
