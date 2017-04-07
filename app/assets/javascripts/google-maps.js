function initMap() {
  // Create the map.
  var map = new google.maps.Map(document.getElementById('country-map'), {
    zoom: 2,
    center: {lat: 37.090, lng: 0.0},
    mapTypeId: 'terrain'
  });

  $.get("/countries", function(countries) {
    for(var n in countries) {
      var country = countries[n]
      var radius = Math.log10(country.companies.length + 1) * 100000
      new google.maps.Circle({
        strokeColor: '#FF0000',
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: '#FF0000',
        fillOpacity: 0.35,
        map: map,
        center: {
          lat: country.lat,
          lng: country.lng
        },
        radius: radius
      })
    }
  });
}
