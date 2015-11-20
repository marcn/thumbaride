
 
if (Meteor.isClient) {

	Meteor.startup(function () {
		GoogleMaps.load({libraries:'geometry,places'});
	});

}


if (Meteor.isServer) {

	// Define externally-visible methods here
	Meteor.methods({
		"mobileLogin": function (args) {
			var new_user = args[0];

			// Check if user is already in the DB
			var user = db.users.find({
				"services": {
					"facebook": {
						"id": new_user["id"]
					}
				}
			});

			// If not, add a user to the DB
			if (user == null) {
				var user_id = Users.insert({
					"profile": {
						"name": new_user["name"]
					}, "services": {
						"facebook": {
							"accessToken": new_user[""],
							"email": new_user["email"],
							"id": new_user["id"],
							"name": new_user["name"]
						}
					}
				});
			}

			return {"method": "mobileLogin", "data": {"userId": user_id}};
		},

		"resetData": function() {
			// For resetting/reloading the Pandas collection to default state
			Pandas.remove({});
			loadTestData();
		},
		
		"listDrivers" : function (lat, lon) {
			return Pandas.find({type : "driver"}, {sort: {createdAt: -1}});

		},
		
		"listThumbs" : function (lat, lon) {			
			return Pandas.find({type : "passenger"}, {sort: {createdAt: -1}});
		},

		"pickupThumbs" : function (driverFBId, passengerFBId) {
			
			Pandas.update({fb_id: driverFBId}, {$push: {passengers: passengerFBId}})
			
			Pandas.update({fb_id: passengerFBId}, {$set: {status: "foundride"}})
			Pandas.update({fb_id: passengerFBId}, {$set: {driver: driverFBId}})			
			
		},
		"foundriders" : function (driverFBId) {
			Pandas.update({fb_id : driverFBId}, {$set: {status: "foundriders"}});
		}						
	});

}
