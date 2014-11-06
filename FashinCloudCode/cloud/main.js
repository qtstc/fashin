
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {



  	response.success("This is twillio from tao!");
});

Parse.Cloud.afterSave("Requests", function(request) {
	var rId = request.object.id;

	// Find users near a given location
	var userQuery = new Parse.Query(Parse.User);
	userQuery.equalTo('typeOfUser','stylist');
	 
	// Find devices associated with these users
	var pushQuery = new Parse.Query(Parse.Installation);
	pushQuery.matchesQuery('userObject', userQuery);
	
	// Require and initialize the Twilio module with your credentials
	var client = require('twilio')('ACfe3e967f503baad3edba55c72e89421c', '63fda8f881f773ed7f3f456d9a8f56f9');
	// Send an SMS message
	client.sendSms({
	  to:'+13177014928', 
	  from: '+16122947233', 
	  body: 'You have a new fashion advice request.'
	}, function(err, responseData) { 
	  if (err) {
	    console.log(err);
	  } else { 
	    console.log(responseData.from); 
	    console.log(responseData.body);
	  }
	}
	);

	// Send push notification to query
	Parse.Push.send({
	  where: pushQuery,
	  data: {
	    alert: "You have a new fashion advice request.",
	    requestId:rId
	  }
	}, {
	  success: function() {
	    // Push was successful
	  },
	  error: function(error) {
	    // Handle error
	  }
	});	
});
