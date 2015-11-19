if (Meteor.isClient) {
  // counter starts at 0
  Session.setDefault('counter', 0);

  Template.hello.helpers({
	counter: function () {
	  return Session.get('counter');
	}
  });

  Template.hello.events({
	'click button': function () {
	  // increment the counter when button is clicked
	  Session.set('counter', Session.get('counter') + 1);
	}
  });
}

if (Meteor.isServer) {
  Meteor.methods({
	"mobileLogin" : function(args) {
	  var new_user = args[0];

	  var user = db.users.find({ 
		"services" : {
		  "facebook" : {
			"id" : new_user["id"]
		  }
		}
	  });

	  if ( user == null) {
		var user_id = Users.insert({
		  "profile" : {
			"name" : new_user["name"]
		  }, "services" : {
			"facebook" : {
			  "accessToken" : new_user[""],
			  "email" : new_user["email"],
			  "first_name" : new_user["first_name"],
			  "last_name" : new_user["last_name"],
			  "id" : new_user["id"],
			  "name" : new_user["name"],
			}
		  }
		}); 
	  }

	  return {"method" : "login", "data" : {"userId" : user_id}};
	}
  });
}