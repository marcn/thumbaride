
Meteor.startup(function () {
	if ("geolocation" in navigator) {
		navigator.geolocation.getCurrentPosition(function (position) {
			// TODO: if this is called before auth, then it's not called again post-auth and map won't have our name/image
			Session.set("currentUserInfo", {
				name: Meteor.user() ? Meteor.user().services.facebook.name : "",
				fb_id: Meteor.user() ? Meteor.user().services.facebook.id : "",
				from_location: [position.coords.longitude, position.coords.latitude],
	            to_location: [position.coords.longitude, position.coords.latitude],
				status: "self",
				passengers : [],
				driver : null,
				type: "observer"
			});
		});
	}
});
