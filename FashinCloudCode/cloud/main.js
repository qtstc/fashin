// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  	response.success("This is twillio from tao!");
});

Parse.Cloud.define("respondRequest", function(request,response){
  var rID = request.params.requestID;
  var isAccepted = request.params.isAccepted;
  var Requests = Parse.Object.extend("Requests");
  var requestQuery = new Parse.Query(Requests);
  // Frist get the request by ID
  requestQuery.get(rID, {
    success: function(request) {
      if(isAccepted)
      {
        request.set('status',"chatting");
        request.save(null, {
          success: function(request) {

            console.log("Status updated to chatting for request: "+rID);
            // Now we notifiy the user through push
            var pushQuery = new Parse.Query(Parse.Installation);
            pushQuery.equalTo('userObject', request.get('customerObject'));
            Parse.Push.send({
              where: pushQuery,
              data: {
                alert: "Your personal stylist is now online. Launch the app to continue.",
                requestId:rID
              }
            }, {
              success: function() {
                response.success("Push sent successfully to customer for new match(chatting) "+request.get('customerObject').id);
              },
              error: function(error) {
                response.fail("Failed to send push to customer for new match(chatting) "+request.get('customerObject').id);
              }
            });
          },
          error: function(object,error) {
            response.fail("Error while updating the chatting for request:"+rID+":"+error);
          }
        });
      }else
      {
        // First add the current stylist to rejected
        var rejected = request.get('rejected');
        if (rejected == null)
        {
          rejected = [];
        }
        rejected.push(request.get('stylistObject').id);
        request.set('rejected',rejected);
        request.save(null, {
          success: function(request){
            Parse.Cloud.run('pingStylist', {requestID:request.id}, {
              success: function(result) {
                response.success("Pinged other stylists!");
              },
              error: function(error) {
                response.fail("Failed to ping other stylists:"+rID+":"+error);
              }
            });
          },
          error:function(object, error){
            response.fail("Error while updating the rejected array for:"+rID+":"+error);
          }
        });
      }
    },
    error: function(object, error) {
      response.fail("Failed to get request:"+rID+":"+error);
    }
  });
});

Parse.Cloud.define("pingStylist", function(request, response){
  var rID = request.params.requestID;
  console.log("The request ID is "+rID);

  var Requests = Parse.Object.extend("Requests");
  var requestQuery = new Parse.Query(Requests);
  // Frist get the request by ID
  requestQuery.get(rID, {
    success: function(request) {
      //Get all the stylists which rejected
      var rejected = request.get('rejected');
      //If there weren't any, use empty array
      if (rejected == null)
      {
        rejected = [];
      }
      var userQuery = new Parse.Query(Parse.User);
      userQuery.equalTo('typeOfUser','stylist');
      userQuery.notContainedIn('objectId',rejected);
      //We only need one
      userQuery.limit(1);
      //Get the stylist which is last active
      userQuery.descending('updatedAt');
      userQuery.find({
        success: function(results) {
          // If there is no result
          if(results.length == 0)
          {
            request.set('status','nomatch');
            request.save(null, {
              success: function(request) {

                console.log("No match for request: "+rID);
                // Now we notifiy the user through push
                var pushQuery = new Parse.Query(Parse.Installation);
                pushQuery.equalTo('userObject', request.get('customerObject'));
                Parse.Push.send({
                  where: pushQuery,
                  data: {
                    alert: "We're sorry, no stylists are available right now. Check back again soon!",
                    requestId:rID
                  }
                }, {
                  success: function() {
                    response.success("Push sent successfully to customer for nomatch "+request.get('customerObject').id);
                  },
                  error: function(error) {
                    response.fail("Failed to send push to customer for nomatch "+request.get('customerObject').id);
                  }
                });
              },
              error: function(object, error) {
                response.fail("Error while updating the nomatch for request:"+rID+":"+error);
              }
            });
          }else
          {
            request.set('stylistObject',results[0]);
            request.set('status','matching');
            request.save(null, {
              success: function(request) {
                console.log("Matching for request: "+rID);
                // Now we push to stylist
                var pushQuery = new Parse.Query(Parse.Installation);
                pushQuery.equalTo('userObject', results[0]);
                // Send push notification to query
                Parse.Push.send({
                  where: pushQuery,
                  data: {
                    alert: "You have a new fashion advice request.",
                    requestId:rID
                  }
                }, {
                  success: function() {
                    response.success("Push sent successfully to stylist "+results[0].id);
                  },
                  error: function(error) {
                    response.fail("Failed to send push to stylist "+results[0].id);
                  }
                });
              },
              error: function(object, error) {
                response.fail("Error when matching for request:"+rID+":"+error);
              }
            });
          }
        }
      });
    },
    error: function(object, error) {
      response.fail("Failed to get request:"+rID+":"+error);
    }
  });
});

/*
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
*/

Parse.Cloud.define("generateToken", function(request, response) {
  var fs = require('fs');
  var layer = require('cloud/layer-parse-module/layer-module.js');
  var layerProviderID = 'f147fdb2-19c1-11e4-a0e9-a19800003b1a';
  var layerKeyID = 'bac90d30-7bcd-11e4-a52a-75bc00007755';
  var privateKey = fs.readFileSync('cloud/layer-parse-module/keys/layer-key.js');
  layer.initialize(layerProviderID, layerKeyID, privateKey);

  var userID = request.params.userID;
  var nonce = request.params.nonce
  if (!userID) throw new Error('Missing userID parameter');
  if (!nonce) throw new Error('Missing nonce parameter');
      response.success(layer.layerIdentityToken(userID, nonce));
});
