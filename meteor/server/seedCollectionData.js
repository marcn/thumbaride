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
			fb_id: "500010526",
			lat: "37.885309",
			long: "-122.266338"
		});
	}

	if (Passengers.find().count() == 0) {
		Passengers.insert({
			user_id: 3,
			name: "Chris Phillips",
			fb_id: "100000184415527",
			lat: "37.971545",
			long: "-122.027786"
		});

		Passengers.insert({
			user_id: 4,
			name: "Tom Conrad",
			fb_id: "500013004",
			lat: "37.887345",
			long: "-122.081706"
		});
	}

});