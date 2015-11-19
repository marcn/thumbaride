
Template.driver_test.helpers({
	drivers: function() {
		return Drivers.find({}, {sort: {createdAt: -1}});
	}
});