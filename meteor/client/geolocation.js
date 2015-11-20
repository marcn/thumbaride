
Meteor.startup(function () {
	if ("geolocation" in navigator) {
		navigator.geolocation.getCurrentPosition(function (position) {
			Session.set("position", [position.coords.longitude, position.coords.latitude]);
		});
	}

	Tracker.autorun(function() {
		var user = Meteor.user();
		var position = Session.get("position");
		if (user) {
			Session.set("currentUserInfo", {
				name: user.services.facebook.name,
				fb_id: user.services.facebook.id,
				from_location: position,
	            to_location: position,
				status: "self",
				passengers : [],
				driver : null,
				type: "observer"
			});
		}
	});
});
