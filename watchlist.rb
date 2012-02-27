require 'sinatra'
require 'dm-core'
require 'dm-migrations'
require 'json'
require 'geocoder'

DataMapper::setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')

class Building
  include DataMapper::Resource
  property :id, Serial
  property :address, String
  property :borough, String
  property :units, Integer
  property :total_infractions, Integer
   property :a_infractions, Integer
    property :b_infractions, Integer
     property :c_infractions, Integer
      property :i_infractions, Integer
  property :landlord, String    
  property :latitude, Float
  property :longitude, Float
end

get '/geocoded/lat=:lat&lon=:lon.json' do
  lat = params[:lat].to_f
  lon = params[:lon].to_f
origin = [lat, lon]
@buildings = Array.new
Building.select do |p|
  dest = [p.latitude, p.longitude]
  if Geocoder::Calculations.distance_between(origin, dest) < 0.5
    @buildings.push p 
  end
end
content_type :json
  return {:response => [@buildings.inspect]}.to_json
end