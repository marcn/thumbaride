
PANDORA_OFFICE_COORDS = [-122.266034, 37.810322];

function addDistanceTransform(item) {
	var currentUserInfo = Session.get("currentUserInfo");
	var a = new google.maps.LatLng(currentUserInfo.from_location[1], currentUserInfo.from_location[0]);
	var b = new google.maps.LatLng(item.from_location[1], item.from_location[0]);
	var distance = google.maps.geometry.spherical.computeDistanceBetween(a, b);		// in meters
	item['distance'] = Math.round(distance / 100) / 10;
	return item;
}

Template.driver_table.helpers({
	drivers: function() {
		var currentUserInfo = Session.get("currentUserInfo");
		if (currentUserInfo && GoogleMaps.loaded()) {
			return Pandas.find({type: "driver", from_location: { $near: currentUserInfo.from_location, $maxDistance: 100.00}}, {transform: addDistanceTransform});
		}
	}
});

Template.passenger_table.helpers({
	passengers: function() {
		var currentUserInfo = Session.get("currentUserInfo");
		if (currentUserInfo && GoogleMaps.loaded()) {
			return Pandas.find({type: "passenger", from_location: { $near: currentUserInfo.from_location, $maxDistance: 100.00}}, {transform: addDistanceTransform});
		}
	}
});