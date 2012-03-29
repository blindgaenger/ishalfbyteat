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
  def is_friend?(user_id)
    $foursquare.user_friends('self')['items'].map{|u| u.id}.include? user_id
  end

  # checking where the user is right now
  # may result in multiple venues at the same time
  def here_now?(user_id, venue_id)
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

get '/stylesheets/:file.css' do
  sass "stylesheets/#{params[:file]}".to_sym
end

get '/' do
  if venue = params[:venue]
    redirect to("/#{URI.encode venue}")
  elsif !is_friend?(ENV['FOURSQUARE_USER_ID'])
    haml :start
  else
    haml :home
  end
end

get '/:venue' do
  @venue = params[:venue]
  if @venue == ENV['FOURSQUARE_VENUE_NAME']
    @here = here_now?(ENV['FOURSQUARE_USER_ID'], ENV['FOURSQUARE_VENUE_ID'])
    haml :venue_known
  else
    haml :venue_unknown
  end
end
