function initMap() {
  var map = L.map('world-map').setView([51.505, -20.09], 2)

  L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>',
		maxZoom: 4
	}).addTo(map)

  $.get("/countries", function(countries) {
    for(var n in countries) {
      var country = countries[n]
      var radius = Math.log10(country.company_count + 1) * 100000

      var circle = L.circle([country.lat, country.lng], {
        color: '#a941f4',
        fillColor: '#a941f4',
        fillOpacity: 0.5,
        radius: radius
      })
      circle.bindTooltip(country.name + "<br>" + country.company_count + ' companies').openTooltip()
      circle.addTo(map)
      // new google.maps.Circle({
      //   strokeColor: '#FF0000',
      //   strokeOpacity: 0.8,
      //   strokeWeight: 2,
      //   fillColor: '#FF0000',
      //   fillOpacity: 0.35,
      //   map: map,
      //   center: {
      //     lat: country.lat,
      //     lng: country.lng
      //   },
      //   radius: radius
      // })
    }
  })
}

function initMapGoogle() {
  // Create the map.
  var map = new google.maps.Map(document.getElementById('country-map'), {
    zoom: 2,
    center: {lat: 37.090, lng: 0.0},
    mapTypeId: 'terrain'
  });

  $.get("/countries", function(countries) {
    for(var n in countries) {
      var country = countries[n]
      var radius = Math.log10(country.company_count + 1) * 100000
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
