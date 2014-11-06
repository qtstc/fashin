
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
	// Find users near a given location
	var userQuery = new Parse.Query(Parse.User);
	userQuery.equalTo('typeOfUser','stylist');
	 
	// Find devices associated with these users
	var pushQuery = new Parse.Query(Parse.Installation);
	pushQuery.matchesQuery('userObject', userQuery);
	 
	// Send push notification to query
	Parse.Push.send({
	  where: pushQuery,
	  data: {
	    alert: "heyyyyyy, push is working, taoaoaoaoao"
	  }
	}, {
	  success: function() {
	    // Push was successful
	  },
	  error: function(error) {
	    // Handle error
	  }
	});	
  	response.success("This is the response from tao!");
});

Parse.Cloud.afterSave("Requests", function(request) {
	var rId = request.object.id;

	// Find users near a given location
	var userQuery = new Parse.Query(Parse.User);
	userQuery.equalTo('typeOfUser','stylist');
	 
	// Find devices associated with these users
	var pushQuery = new Parse.Query(Parse.Installation);
	pushQuery.matchesQuery('userObject', userQuery);
	 
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
