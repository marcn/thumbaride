
Meteor.startup(function () {
	if ("geolocation" in navigator) {
		navigator.geolocation.getCurrentPosition(function (position) {
			console.log("Location: ", position);
			Session.set("currentUserInfo", {
				// TODO: generator function for Panda data?
				name: Meteor.user().services.facebook.name,
				fb_id: Meteor.user().services.facebook.id,
				from_location: [position.coords.latitude, position.coords.longitude],
	            to_location: [position.coords.latitude, position.coords.longitude],
				//status: PASSENGER_STATE.FOUNDRIDE.name,
				passengers : [],
				driver : null,
				type: "observer"
			});
		});
	}
});
