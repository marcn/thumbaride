// Seed the collections with data, if needed
Meteor.startup(function () {

	if (Drivers.find().count() == 0) {
		Drivers.insert({
			user_id: 1,
			name: "Tim Westergren",
			fb_id: "143876005627770",
			from_location: [37.885309, -122.8281246],            
            to_location: [38.0629903, -122.266338],    
			status: "seekingriders"
		});

/*
		Drivers.insert({
			user_id: 2,
			name: "Chris Martin",
			fb_id: "500010526",
			from_location: [-122.266338,37.885309] ,            
            to_location: [-122.266338, 38.0629903],  
			status: "foundriders", 
		});
*/
	}
	/*
	if (Passengers.find().count() == 0) {
		Passengers.insert({
			user_id: 3,
			name: "Chris Phillips",
			fb_id: "100000184415527",
			from_location: [-122.027786,37.971545],            
            to_location: [-122.266338, 38.0629903],  
			status: "needride"
		});

		Passengers.insert({
			user_id: 4,
			name: "Tom Conrad",
			fb_id: "500013004",
			from_location: [-122.081706,37.887345],             
            to_location: [-122.266338, 38.0629903],   
			status: "foundride"
		});
	}
	*/

});