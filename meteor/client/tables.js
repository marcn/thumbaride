
PANDORA_OFFICE_COORDS = [-122.266034, 37.810322];

function addDistanceTransform(item) {
	var currentUserInfo = Session.get("currentUserInfo");
	if (currentUserInfo && currentUserInfo.from_location) {
		var a = new google.maps.LatLng(currentUserInfo.from_location[1], currentUserInfo.from_location[0]);
		var b = new google.maps.LatLng(item.from_location[1], item.from_location[0]);
		var distanceMeters = google.maps.geometry.spherical.computeDistanceBetween(a, b);
		var distanceMiles = distanceMeters * 0.000621371;
		item['distance'] = Math.round(distanceMiles * 10) / 10;	// show accuracy to 0.1 mile
		item['distance'] = item['distance']+'mi';
	} else {
		item['distance'] = "-";
	}
	return item;
}

Template.driver_table.helpers({
	drivers: function() {
		var currentUserInfo = Session.get("currentUserInfo");
		var location = PANDORA_OFFICE_COORDS;
		if (currentUserInfo && currentUserInfo.from_location) {
			location = currentUserInfo.from_location;
		}
		if (GoogleMaps.loaded()) {
			return Pandas.find({type: "driver", from_location: { $near: location, $maxDistance: 100.00}}, {transform: addDistanceTransform});
		}
	}
});

Template.passenger_table.helpers({
	passengers: function() {
		var currentUserInfo = Session.get("currentUserInfo");
		var location = PANDORA_OFFICE_COORDS;
		if (currentUserInfo && currentUserInfo.from_location) {
			location = currentUserInfo.from_location;
		}
		if (GoogleMaps.loaded()) {
			return Pandas.find({type: "passenger", from_location: { $near: location, $maxDistance: 100.00}}, {transform: addDistanceTransform});
		}
	}
});