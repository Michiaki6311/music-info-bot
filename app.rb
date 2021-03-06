require 'sinatra'
require 'json'
require 'active_record'
require 'sinatra/activerecord'
require 'open-uri'
require 'uri'

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
        response = "登録画面: http://kanadebito63-music-info-bot.herokuapp.com/add"
      elsif e['message']['text'] == "#music list" then
        response = "一覧画面: https://kanadebito63-music-info-bot.herokuapp.com/show"
      else
        ""
    end
  }
end

delete '/del' do
  del = Item.find(params[:id])
  del.destroy
  redirect '/show'
end

post '/search' do
  key = ENV['DEVELOPER_KEY']
  searchword = ""
  j = JSON.parse(request.body.string)
  j['events'].select{|e| e['message']}.map{|e|
    if e['message']['text'] =~ /^#v/ then
      searchword = e['message']['text']
      elsif e['message']['text'] =~ /^#vf\s/ then
      searchword = e['message']['text']
      else
      searchword = ""
    end
  }
  
  if searchword =~ /^#v\s/ then
    searchword_new = searchword.gsub(/^#v\s/,'').gsub(/\s/,'+')
    url1 = "https://www.googleapis.com/youtube/v3/search?key=#{key}&q=#{searchword_new}&part=id,snippet"
    url2 = URI.encode(url1)
   j = open(url2)
   data = j.read
   json = JSON.parse(data)
   array = []
   json['items'].select{|e| e['id']}.map{|e|
    if e['id']['videoId'] then
     url3 = "https://www.youtube.com/watch?v=#{e['id']['videoId']}\n"
     array.push(url3)
    else
     ""
    end
   }
   array.first
   elsif searchword =~ /^#vf\s/ then
   searchword_new = searchword.gsub(/^#vf\s/,'').gsub(/\s/,'+')
    url1 = "https://www.googleapis.com/youtube/v3/search?key=#{key}&q=#{searchword_new}&part=id,snippet"
    url2 = URI.encode(url1)
   j = open(url2)
   data = j.read
   json = JSON.parse(data)
   array = []
   json['items'].select{|e| e['id']}.map{|e|
    if e['id']['videoId'] then
     url3 = "https://www.youtube.com/watch?v=#{e['id']['videoId']}\n"
     array.push(url3)
    else
     ""
    end
   }
   array.each{|arr|
   arr
   }
 else
   ""
  end
end