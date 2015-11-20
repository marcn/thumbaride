var infowindow;
var line;



function getInfoWindow(document){
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

function getIcon(status){
	var icon = "/img/"
	if (status == "needride"){
		icon = icon + "icon-thumb-noride.png"
	}else if (status == "foundride"){
		icon = icon + "icon-thumb-ride.png"
	}else if ((status == "seekingriders") ||  (status == "foundriders")){
		icon = icon + "icon-car-small.png"
	} 

	return icon;
}

function addMarkers(document, map){

	//map.controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(
  	//document.getElementById('legend'));

	var from = new google.maps.Marker({
					animation: google.maps.Animation.DROP,
					position: new google.maps.LatLng(document.from_location[0], document.from_location[1]),
					map: map.instance,
					id: document._id,
					title: document.name, 
					customInfo: document,
					icon: getIcon(document.status)
				});
	var to = new google.maps.Marker({
					animation: google.maps.Animation.DROP,
					position: new google.maps.LatLng(document.to_location[0], document.to_location[1]),
					map: map.instance,
					id: document._id,
					title: document.name, 
					customInfo: document,
					icon: getIcon(document.status)
				});

	
	var mouseOver = function (e) {

		if (line) {
	        line.setMap(null);
	    }

		line = new google.maps.Polyline({
		    path: [
		        from.getPosition(), 
		        to.getPosition()
		    ],
		    strokeColor: "#FF0000",
		    strokeOpacity: 1.0,
		    strokeWeight: 10,
		    map: map.instance
		});
	}

	var mouseOut = function (e) {
		if (line) {
	        line.setMap(null);
	    }
	}

	from.addListener('mouseover', mouseOver);
	to.addListener('mouseover', mouseOver);
	from.addListener('mouseout', mouseOut);
	to.addListener('mouseout', mouseOut);

	from.addListener('click', function (e) {

		if (infowindow) {
	        infowindow.close();
	    }
    
		infowindow = new google.maps.InfoWindow({
					//content: $("#infoWindowTmpl").tmpl(document), 
					content: getInfoWindow(this.customInfo), 
					maxWidth: 200
				});

		infowindow.open(map.instance, from);
	});

	to.addListener('click', function (e) {

		if (infowindow) {
	        infowindow.close();
	    }
    
		infowindow = new google.maps.InfoWindow({
					//content: $("#infoWindowTmpl").tmpl(document), 
					content: getInfoWindow(this.customInfo), 
					maxWidth: 200
				});

		infowindow.open(map.instance, to);
	});

	return [from, to];
}



Template.map.onCreated(function () {
	GoogleMaps.ready('map', function (map) {
		var markers = {};
		Pandas.find().observe({
			added: function (document) {
				markers[document._id] = addMarkers(document, map);;
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
				markers[document._id] = addMarkers(document, map, "driver");;
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
