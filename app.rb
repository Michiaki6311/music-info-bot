require 'sinatra'
require 'json'
require 'active_record'
require 'sinatra/activerecord'

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || 'postgres://amfzhtdoyvixst:dyR7kstCVyDT6HCs3bY4cbGqAr@ec2-54-235-89-113.compute-1.amazonaws.com:5432/daeo4qlo2s0b9q')

class Item < ActiveRecord::Base
  validates_presence_of :title, :artist, :genre, :url
  validates_uniqueness_of :url
end

get '/' do
  'Hello,World!'
end

get '/add' do
  @title = "Music Information"
  erb :index
end

post '/add' do
  music = Item.new
  music.title  = params[:title].downcase
  music.artist = params[:artist].downcase
  music.genre  = params[:genre].downcase
  music.url    = params[:url]
  if music.save
    music.save
    redirect '/add'
  else
    erb :error
  end
end

get '/show' do
  @title = "Music Information List"
  @items = Item.all
  erb :show
end

post '/lingr' do
  j = JSON.parse(request.body.string)
  j['events'].select{|e| e['message']}.map{|e|
    if e['message']['text'] == "#music post" then
      Item.order('RANDOM()').limit(1).first.url
      elsif e['message']['text'] == "#music add" then
        response = "http://kanadebito63-music-info-bot.herokuapp.com/add"
      elsif e['message']['text'] == "#music list" then
        response = "https://kanadebito63-music-info-bot.herokuapp.com/show"
      else
        ""
    end
  }
end