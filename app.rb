# encoding: UTF-8

require 'sinatra'
require 'sinatra/content_for'
require 'sinatra/reloader' if development?
require 'haml'
require 'sass'
require 'foursquare2'

$foursquare = Foursquare2::Client.new(:oauth_token => ENV['FOURSQUARE_OAUTH_TOKEN'])

configure do
  set :haml, :format => :html5 # default Haml format is :xhtml
  set :sass, :style => :compact # default Sass style is :nested, :expanded
end

helpers do
  def here_now?(venue_id, user_id)
    venue = $foursquare.venue(venue_id)
    return nil unless venue

    checkins = venue.hereNow.groups.map{|g| g.items}.flatten
    return false if checkins.empty?

    ids = checkins.map{|c| c.user.id}
    return ids.include? user_id
  rescue
    nil
  end
end

get '/' do
  @here = here_now?(ENV['FOURSQUARE_VENUE_ID'], ENV['FOURSQUARE_USER_ID'])
  haml :index
end

get '/stylesheets/:file.css' do
  sass "stylesheets/#{params[:file]}".to_sym
end
