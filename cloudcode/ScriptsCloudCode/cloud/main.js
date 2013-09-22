
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});


//Send Push after something is saved. 
Parse.Cloud.afterSave("StoryEntry", function(request) {
  // Our "Comment" class has a "text" key with the body of the comment itself
  var storyEntryText = request.object.get('text');
 
  var pushQuery = new Parse.Query(Parse.Installation);
  pushQuery.equalTo('deviceType', 'ios');
    
  Parse.Push.send({
    where: pushQuery, // Set our Installation query
    data: {
      alert: "New story entry: " + storyEntryText
    }
  }, {
    success: function() {
      // Push was successful
      console.log("Push sent successfulluy!!"); 
    },
    error: function(error) {
      throw "Got an error " + error.code + " : " + error.message;
    }
  });
});