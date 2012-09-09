class RestaurantsController < ApplicationController
  def index
    url = "https://api.foursquare.com/v2/venues/explore?" +
            "ll=#{params[:lat]},#{params[:lng]}" +
            "&section=food" +
            "&limit=10" +
            "&oauth_token=#{current_user}"
    foursquare_json = HTTParty.get(url)
    @restaurants = foursquare_json['response']['groups'][0]['items']
  end

  def show
    @name = params[:name]
    @lat = params[:lat]
    @lng = params[:lng]
    
    @venue-id = venue_id name, lat, lng
  end

  private 

  def venue_id(name, lat, lng)
    url = "http://api.locu.com/v1_0/venue/search/?" +
            "name=#{name}" +
            "&location=#{lat},#{lng}"

    json_response = HTTParty.get(url)

    json_response['objects'][0]['id']
  end
end
