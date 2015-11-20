
 
if (Meteor.isClient) {

	Meteor.startup(function () {
		GoogleMaps.load();
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
		
		"listDrivers" : function (args) {
		
			var lat = args[0];
			var long = args[1];
			
			return Pandas.find({type : "driver"}, {sort: {createdAt: -1}});

		},
		
		"listThumbs" : function (args) {
		
			var lat = args[0];
			var long = args[1];
			
			return Pandas.find({type : "passenger"}, {sort: {createdAt: -1}});
		},

		"pickupThumbs" : function (args) {
		
			var driverFBId = args[0];
			var passengerFBId = args[1];
			
			Pandas.update(driverFBId, {$push: {passengers: passengerFBId}})
			
			Pandas.update(passengerFBId, {$set: {status: "foundride"}})
			Pandas.update(passengerFBId, {$set: {driver: driverFBId}})			
		}		
		
		
	});

}
