class RestaurantsController < ApplicationController
  def index
    page = params[:page].to_i
    start = page * 10
    finish = start + 10
    url = "https://api.foursquare.com/v2/venues/explore?" +
            "ll=#{params[:lat]},#{params[:lng]}" +
            "&section=food" +
            "&limit=50" +
            "&page=#{page}" +
            "&oauth_token=#{current_user}"
    foursquare_json = HTTParty.get(url)
    @restaurants = foursquare_json['response']['groups'][0]['items'][start..finish]
  end

  def show
    name = params[:name]
    lat = params[:lat]
    lng = params[:lng]

    @venue_id = venue_id(name, lat, lng)
  end

  private

  def venue_id(name, lat, lng)
    url = "http://api.locu.com/v1_0/venue/search/?" +
            "name=#{name}" +
            "&location=#{lat},#{lng}" +
            "&api_key=3dda222999dbaf88ac2f518af360254d8656bc4e"

    json_response = HTTParty.get(URI.encode(url))

    json_response['objects'][0]['id'] rescue nil
  end
end
