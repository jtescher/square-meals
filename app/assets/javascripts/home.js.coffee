# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


redirectToLatLng = (position) ->
    lat = position.coords.latitude
    lng = position.coords.longitude
    window.location.href = "/restaurants?lat=#{lat}&lng=#{lng}"


geoError = ->
    alert('This app requires geolocation')


getRestaurants = ->
    if navigator.geolocation
        navigator.geolocation.getCurrentPosition redirectToLatLng, geoError
    else
        geoError()


jQuery ->
    if $('#restaurants-container').length
        getRestaurants()