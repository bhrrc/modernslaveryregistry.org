// This example creates circles on the map, representing populations in North
// America.

// First, create an object containing LatLng and population for each city.
var citymap = {
  chicago: {
    center: {lat: 41.878, lng: -87.629},
    population: 2714856
  },
  newyork: {
    center: {lat: 40.714, lng: -74.005},
    population: 8405837
  },
  losangeles: {
    center: {lat: 34.052, lng: -118.243},
    population: 3857799
  },
  vancouver: {
    center: {lat: 49.25, lng: -123.1},
    population: 603502
  }
};

function initMap() {
  // Create the map.
  var map = new google.maps.Map(document.getElementById('country-map'), {
    zoom: 1,
    center: {lat: 37.090, lng: -95.712},
    mapTypeId: 'terrain'
  });

  $.get("/countries", function(countries) {
    for(var n in countries) {
      var country = countries[n]
      var radius = Math.sqrt(country.companies.length) * 10000
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

  // Construct the circle for each value in citymap.
  // Note: We scale the area of the circle based on the population.
  // for (var city in citymap) {
  //   // Add the circle for this city to the map.
  //   var cityCircle = new google.maps.Circle({
  //     strokeColor: '#FF0000',
  //     strokeOpacity: 0.8,
  //     strokeWeight: 2,
  //     fillColor: '#FF0000',
  //     fillOpacity: 0.35,
  //     map: map,
  //     center: citymap[city].center,
  //     radius: Math.sqrt(citymap[city].population) * 100
  //   });
  // }
}
