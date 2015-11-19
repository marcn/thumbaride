
Template.passenger_test.helpers({
	passengers: function() {
		//return Pandas.find({}, {sort: {createdAt: -1}});
		
		return Pandas.find({type : "passenger"}, {sort: {createdAt: -1}});

	}
});
