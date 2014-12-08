var fs = require('fs');
var layer = require('cloud/layer-parse-module/layer-module.js');
var layerProviderID = 'f147fdb2-19c1-11e4-a0e9-a19800003b1a';
var layerKeyID = 'bac90d30-7bcd-11e4-a52a-75bc00007755';
var privateKey = fs.readFileSync('cloud/layer-parse-module/keys/layer-key.js');
layer.initialize(layerProviderID, layerKeyID, privateKey);

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

Parse.Cloud.define("generateToken", function(request, response) {
    var userID = request.params.userID;
    var nonce = request.params.nonce
    if (!userID) throw new Error('Missing userID parameter');
    if (!nonce) throw new Error('Missing nonce parameter');
        response.success(layer.layerIdentityToken(userID, nonce));
});
