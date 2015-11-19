
Template.passenger_test.helpers({
	passengers: function() {
		return Passengers.find({}, {sort: {createdAt: -1}});
	}
});