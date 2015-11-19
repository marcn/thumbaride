// Seed the collections with data, if needed
Meteor.startup(function () {

	if (Drivers.find().count() == 0) {
		Drivers.insert({
			user_id: 1,
			name: "Tim Westergren",
			fb_id: "143876005627770",
			lat: "38.0629903",
			long: "-122.8281246"
		});

		Drivers.insert({
			user_id: 2,
			name: "Chris Martin",
			fb_id: "10155900444455527",
			lat: "37.885309",
			long: "-122.266338"
		});
	}

	if (Passengers.find().count() == 0) {
		Passengers.insert({
			user_id: 3,
			name: "Chris Phillips",
			fb_id: "1051125341570270",
			lat: "37.971545",
			long: "-122.027786"
		});
	}

});