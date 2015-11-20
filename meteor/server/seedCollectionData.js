// Seed the collections with data, if needed
Meteor.startup(function () {


	var PASSENGER_STATE = {
  		NEEDRIDE : {value: 0, name: "needride", code: "nr"}, 
  		FOUNDRIDE: {value: 1, name: "foundride", code: "fr"}
	};
	
	var DRIVER_STATE = {
  		SEEKINGRIDERS : {value: 0, name: "seekingriders", code: "sr"}, 
  		FOUNDRIDERS: {value: 1, name: "foundriders", code: "fr"}
	};
	
	var TYPE = {
  		driver : {value: 0, name: "driver", code: "d"}, 
  		PASSENGER : {value: 0, name: "passenger", code: "p"}
	};


	if (Pandas.find().count() == 0) {
	
		Pandas.insert({
			name: "Tim Westergren",
			fb_id: "143876005627770",
			from_location: [37.885309, -122.8281246],            
            to_location: [38.0629903, -122.266338],    
			status: DRIVER_STATE.SEEKINGRIDERS.name, 
			passengers : [],
			driver : null,
			type: "driver"
		});

		Pandas.insert({
			name: "Hamid Aghdaee",
			fb_id: "670453378",
			from_location: [37.847610, -122.252005],            
            to_location: [37.810392, -122.265900],    
			status: DRIVER_STATE.SEEKINGRIDERS.name, 
			passengers : [],
			driver : null,
			type: "driver"
		});

		Pandas.insert({
			name: "Chris Martin",
			fb_id: "500010526",
			from_location: [37.885309, -122.266338],            
            to_location: [ 37.885309, -122.266338,] ,
            status: DRIVER_STATE.FOUNDRIDERS.name, 
			passengers : ["100000184415527"],
			driver : null,
			type: "driver"
		});
		
		Pandas.insert({
			name: "Chris Phillips",
			fb_id: "100000184415527",
			from_location: [-122.266338,37.885309],            
            to_location: [-122.266338, 37.885309],  
			status: PASSENGER_STATE.FOUNDRIDE.name, 
			passengers : [],
			driver : "500010526",
			type: "passenger"
		});

		Pandas.insert({
			name: "Tom Conrad1",
			fb_id: "500013004",
			from_location: [-122.266338,37.885309],            
            to_location: [-122.266338, 37.885309],  
			status: PASSENGER_STATE.NEEDRIDE.name, 
			passengers : [],
			driver : null,
			type: "passenger"
		});

		


	}

});