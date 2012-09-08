# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


renderResults = (results) ->
    $restaurantList = $('<ul class="restaurants unstyled"></ul>')
    for restaurant in results
        $restaurant = $('<li class="restaurant"></li>')
        $restaurant.html(restaurant.venue.name)
        $restaurantList.append($restaurant)
    $('.loading-placeholder').replaceWith($restaurantList)


getResultsNear = (lat, lng) ->
    $.ajax
        url: "/restaurants"
        dataType: 'JSON'
        data:
            lat: lat
            lng: lng
        error: -> alert('Sorry something went wrong. Try again later.')
        success: (data) ->
            console.log data
            renderResults(data.response.groups[0].items)


getRestaurants = ->
    if navigator.geolocation
        navigator.geolocation.getCurrentPosition (pos) -> getResultsNear(pos.coords.latitude, pos.coords.longitude)
    else
        alert('This app requires geolocation')

jQuery ->
    if $('#restaurants').length
        getRestaurants()