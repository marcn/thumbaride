var infowindow;

function getInfoWindow(document, type){
	var infoWindow = '<div id="content">' +
	'<div id="siteNotice">' +
	'</div>' +
	'<h1 id="firstHeading" class="firstHeading">' + 
	document.name + 
	'</h1>' +
	'<img src="http://graph.facebook.com/' + 
	document.fb_id + 
	'/picture"/>' + 
	'<div id="bodyContent">' +
	'</div>';

	return infoWindow;

}

function addMarker(document, map, type){

	var marker = new google.maps.Marker({
					animation: google.maps.Animation.DROP,
					position: new google.maps.LatLng(parseFloat(document.lat), parseFloat(document.long)),
					map: map.instance,
					id: document._id,
					title: document.name, 
					type: type, 
					customInfo: document
					//icon:iconBase +  (type === "driver") ? 'driver.png' : 'passenger.png'
				});

	

	
	marker.addListener('click', function (e) {

		if (infowindow) {
	        infowindow.close();
	    }
    
		infowindow = new google.maps.InfoWindow({
					//content: $("#infoWindowTmpl").tmpl(document), 
					content: getInfoWindow(this.customInfo, this.type), 
					maxWidth: 200
				});

		infowindow.open(map.instance, marker);
	});

	return marker;
}



Template.map.onCreated(function () {
	GoogleMaps.ready('map', function (map) {
		var markers = {};
		Drivers.find().observe({
			added: function (document) {
				markers[document._id] = addMarker(document, map, "driver");;
			},
			changed: function (newDocument, oldDocument) {
				markers[newDocument._id].setPosition({lat: parseFloat(newDocument.lat), lng: parseFloat(newDocument.long)});
			},
			removed: function (oldDocument) {
				markers[oldDocument._id].setMap(null);
				google.maps.event.clearInstanceListeners(markers[oldDocument._id]);
				delete markers[oldDocument._id];
			}
		});

		Passengers.find().observe({
			added: function (document) {
				markers[document._id] = addMarker(document, map, "driver");;
			},
			changed: function (newDocument, oldDocument) {
				markers[newDocument._id].setPosition({lat: newDocument.lat, lng: newDocument.lng});
			},
			removed: function (oldDocument) {
				markers[oldDocument._id].setMap(null);
				google.maps.event.clearInstanceListeners(markers[oldDocument._id]);
				delete markers[oldDocument._id];
			}
		});
	});
});

Template.map.helpers({
	mapOptions: function () {
		if (GoogleMaps.loaded()) {
			return {
				center: new google.maps.LatLng(37.8103920, -122.2659000),
				zoom: 8
			};
		}
	}
});
