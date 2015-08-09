var express = require('express');
var router = express.Router();
var mongoose = require('mongoose');
var User = require('../models/User.js');
var request = require('request');
var client = require('twilio')('AC4e82cec24753db7a8f59a0b012a014e4', '69507fdc687e81fbaca709aab4905d49');

mongoose.connect("mongodb://dfranc3373:Df10351086km@ds031903.mongolab.com:31903/sense360");

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});

router.post('/SetUserLocation', function(req, res) {
    
    if(req.body.UDID) {
        
        var type = "food";
        
        if(req.body.type == "restaurant") {
            
            type = "food";
            
        } else if(req.body.type == "bar") {
            
            type = "bar";
            
        } else if(req.body.type == "gym") {
            
            type = "gym";
            
        } else if(req.body.type == "airport") {
            
            type = "airport";
            
        }
        
        console.log("Test");
        
        request({ uri: "https://maps.googleapis.com/maps/api/place/radarsearch/json?location=" + req.body.latitude + "," + req.body.longitude + "&radius=5000&types=" + type + "&key=AIzaSyDCzqI9TzdvhIxLXRxH2SfZODNXlVVuyZw", method: 'GET'}, function(err, response, bodydata) {
            
            console.log("https://maps.googleapis.com/maps/api/place/radarsearch/json?location=" + req.body.latitude + "," + req.body.longitude + "&radius=5000&types=" + type + "&key=AIzaSyDCzqI9TzdvhIxLXRxH2SfZODNXlVVuyZw");
              
            console.log(bodydata);
            
            if(err) {
                
                res.status(500).send(JSON.stringify({ Error: err }));
                
            } else {
                
                var locations = JSON.parse(bodydata);
                
                if(locations.results[0]) {
                    
                    var id = locations.results[0].place_id;
                    
                    request({ uri: "https://maps.googleapis.com/maps/api/place/details/json?placeid=" + id + "&key=AIzaSyDCzqI9TzdvhIxLXRxH2SfZODNXlVVuyZw", method: 'GET'}, function(err, response, bodydata) {
              
                        console.log(bodydata);

                        if(err) {

                            res.status(500).send(JSON.stringify({ Error: err }));

                        } else {

                            var location = JSON.parse(bodydata);

                            if(location.result.name != "") {
                                
                                User.findOne({ 'UDID': req.body.UDID + "1" }, function(err, user) {
            
                                            if(err) {

                                                res.status(500).send(JSON.stringify({ Success: false, Error: err }));

                                            } else {
                                                
                                                console.log(location.result.name);

                                                if(!user) {

                                                     var user = new User({ UDID: req.body.UDID + "1", LocationID: id, LocationName: location.result.name, TypeOfLocation: type, WhenTheyArrived: (req.body.WhenTheyArrived != 0 ? req.body.WhenTheyArrived : 0), WhenTheyLeft: (req.body.WhenTheyLeft != 0 ? req.body.WhenTheyLeft: 0), City: location.result.address_components[2].long_name, Latitude: req.body.latitude, Longitude: req.body.longitude });

                                                    user.save(function(err, u) {

                                                        if(err) {

                                                            res.status(500).send(JSON.stringify({ Success: false, Error: err }));
                                                            
                                                            return;

                                                        } else {

                                                            res.status(200).send(JSON.stringify({ Success: true }));
                                                            
                                                            return;

                                                        }

                                                    });

                                                } else {//their is a user that exist
                                                    
                                                    User.update({ 'UDID': req.body.UDID + "1" }, { $set:{ LocationID: id, LocationName: location.result.name, TypeOfLocation: type, WhenTheyArrived: (req.body.WhenTheyArrived != 0 ? req.body.WhenTheyArrived : 0), WhenTheyLeft: (req.body.WhenTheyLeft != 0 ? req.body.WhenTheyLeft: 0), City: location.result.address_components[2].long_name, Latitude: req.body.latitude, Longitude: req.body.longitude } }, { multi: false }, function(err) {

                                                        if(err) {

                                                            res.status(500).send(JSON.stringify({ Success: false, Error: err }));
                                                            
                                                            return;

                                                        } else {

                                                            res.status(200).send(JSON.stringify({ Success: true }));
                                                            
                                                            return;

                                                        }

                                                    });

                                                }

                                            }

                                        });

                                    } else {

                                        res.status(500).send({});

                                    }
                                
                        }
                        
                    });
                            
                } else {

                    res.status(500).send(JSON.stringify({ Error: "Google returned no locations you may not be at a restaurant" }));

                }

            }

        });

    } else {

        res.status(500).send(JSON.stringify({ Error: "Could'nt find UDID" }));

    }
   
});
            
router.post('/GetNumberOfUsersAtLocation', function(req, res) {
    
    if(req.body.LocationID) {
        
        User.find({ 'LocationID': req.body.LocationID, WhenTheyLeft: 0 }, function(err, users) {
            
            console.log(users);
            
            if(err) {
                
                res.status(500).send(JSON.stringify({ Success: false, Error: err }));
                
            } else {
                
                res.status(200).send(JSON.stringify({ UserCount: users.length, Success: true }));
                
            }

        });
        
    } else {
        
        res.status(500).send({});
        
    }
    
});

function getUserCount(Locations, LocationArray, callback) {
    
    if(Locations.constructor !== Array) {
        
        var stack = new Array();
        
        stack.push(Locations);
        
        Locations = stack;
        
    }
    
    console.log(Locations + " " + Locations.length);

    if(Locations.length == 0) {
        
        //console.log(LocationArray);
        
        callback(false, LocationArray);
        
        return;
        
    }
    
    var Location = Locations.shift();
    
    //console.log(Location);
    
    User.find({ "LocationID": Location, WhenTheyLeft: 0 }, function(err, users) {
        
        if(err) {
            
            callback(true);
            
        } else {
            
            if(users.count != 0) {
                
                //console.log(users);

                LocationArray.push({ Location: Location, Count: users.length, LocationName: users[0].LocationName, Latitude: users[0].Latitude, Longitude: users[0].Longitude });

                //console.log(LocationArray);
                
            }
            
            if(Locations.length == 0) {
            
                callback(false, LocationArray);//it worked send the locations and count back
                
                return;
                
            } else {
                
                getUserCount(Locations, LocationArray, callback);
                
            }
            
        }
        
    });
    
}

router.post('/GetNumberOfUsersAtAllLocations', function(req, res) {
    
    var locationCount = [];
    
    User.find().distinct("LocationID", function(err, locations) {

        getUserCount(locations, locationCount, function(err, counts) {
            
            console.log("Function");
            
            if(err) {
                
                res.status(500).send();
                
            } else {
                
            res.status(200).send(JSON.stringify(counts));
                
            }

        });
        
    });
        
});

function sortByKey(array, key, sortByLeast) {
    return array.sort(function(a, b) {
        var x = a[key]; var y = b[key];
        return (sortByLeast ? 1 : -1) * ((x < y) ? -1 : ((x > y) ? 1 : 0));
    });
}

router.post('/GetLeastBusyPlaceTown', function(req, res) {
    
    try {
        
        var text = req.body.Body;
    
        var sms = req.body.From;

        try {
            
            if((text.match(/,/g) || []).length == 0) {
                
                client.sendMessage({

                    to: sms, // Any number Twilio can deliver to
                    from: req.body.To, // A number you bought from Twilio and can use for outbound communication
                    body: 'Hi There! We could not understand your request. Please send a text with what your looking for and the location. Example: Bars, Santa Monica' // body of the SMS message

                    }, function(err, responseData) { //this function is executed when a response is received from Twilio

                        if (!err) { // "err" is an error received during the request, if any

                            // "responseData" is a JavaScript object containing data received from Twilio.
                            // A sample response from sending an SMS message is here (click "JSON" to see how the data appears in JavaScript):
                            // http://www.twilio.com/docs/api/rest/sending-sms#example-1

                            console.log(responseData.from); // outputs "+14506667788"
                            console.log(responseData.body); // outputs "word to your mother."
                            //console.log(exception);
                            
                            res.status(200).send();
                            
                            return;

                        }
                });
                
            }

            var type = text.substr(0, text.indexOf(','));

            if(type.toLowerCase() == "restaurant" || type.toLowerCase() == "restaurants") {

                type = "food";

            } else if(type.toLowerCase() == "bar" || type.toLowerCase() == "bars") {

                type = "bar";

            } else if(type.toLowerCase() == "gym") {

                type = "gym";

            } else if(type.toLowerCase() == "airport") {

                type = "airport";

            }

            var Location;
    
            if((text.match(/,/g) || []).length == 2) {
                
                sort = false;
                
                Location = text.substring(text.indexOf(',') + 2, text.lastIndexOf(','));
                
            } else {
                
                Location = text.substring(text.indexOf(',') + 2);
                
            }
            
            Location = Location.trim();
            
            client.sendMessage({

            to: sms, // Any number Twilio can deliver to
            from: req.body.To, // A number you bought from Twilio and can use for outbound communication
            body: 'Hi There! We are searching for ' + type + ' in ' + Location // body of the SMS message

            }, function(err, responseData) { //this function is executed when a response is received from Twilio

                if (!err) { // "err" is an error received during the request, if any

                    // "responseData" is a JavaScript object containing data received from Twilio.
                    // A sample response from sending an SMS message is here (click "JSON" to see how the data appears in JavaScript):
                    // http://www.twilio.com/docs/api/rest/sending-sms#example-1

                    console.log(responseData.from); // outputs "+14506667788"
                    console.log(responseData.body); // outputs "word to your mother."
                    
                    //res.status(200).send();

            
            console.log(Location + " " + type);
            
            var sort = true;
            
            if((text.match(/,/g) || []).length == 2) {
                
                sort = false;
                
            }

            User.find({ City: Location, TypeOfLocation: type }).distinct("LocationID").exec(function(err, locations) {
                
                if(err) {
                    
                    res.status(500).send("Something went wrong");
                    
                } else {
                    
                    var locationCount = [];
                    
                    console.log(locations);
                    
                    getUserCount(locations, locationCount, function(err, counts) {
                        
                        if(err) {
                            
                            client.sendMessage({

                                to: sms, // Any number Twilio can deliver to
                                from: req.body.To, // A number you bought from Twilio and can use for outbound communication
                                body: 'Sorry we have no data for that area' // body of the SMS message

                                }, function(err, responseData) { //this function is executed when a response is received from Twilio

                                    if (!err) { // "err" is an error received during the request, if any

                                        // "responseData" is a JavaScript object containing data received from Twilio.
                                        // A sample response from sending an SMS message is here (click "JSON" to see how the data appears in JavaScript):
                                        // http://www.twilio.com/docs/api/rest/sending-sms#example-1

                                        console.log(responseData.from); // outputs "+14506667788"
                                        console.log(responseData.body); // outputs "word to your mother."
                                        
                                        res.status(200).send();
                                        
                                        return;

                                    }
                            });
                            
                        } else {
                            
                            counts = sortByKey(counts, "Count", sort);
                            
                            console.log(counts);
                            
                            if(counts.length == 0) {
                            
                                client.sendMessage({

                                    to: sms, // Any number Twilio can deliver to
                                    from: req.body.To, // A number you bought from Twilio and can use for outbound communication
                                    body: "Sorry we could not find any data for the area, please try another spot" // body of the SMS message

                                    }, function(err, responseData) { //this function is executed when a response is received from Twilio

                                        if (!err) { // "err" is an error received during the request, if any

                                            // "responseData" is a JavaScript object containing data received from Twilio.
                                            // A sample response from sending an SMS message is here (click "JSON" to see how the data appears in JavaScript):
                                            // http://www.twilio.com/docs/api/rest/sending-sms#example-1

                                            console.log(responseData.from); // outputs "+14506667788"
                                            console.log(responseData.body); // outputs "word to your mother."
                                            
                                            res.status(200).send();
                                            
                                            return;

                                        }
                                });
                                
                                return;
                                
                            } else {
                                
                                client.sendMessage({

                                    to: sms, // Any number Twilio can deliver to
                                    from: req.body.To, // A number you bought from Twilio and can use for outbound communication
                                    body: (sort ? 'The least busy ' : 'The most busy ') + type + ' are: ' + counts[0].LocationName + (counts[1] ? ", " + counts[1].LocationName : "") + (counts[2] ? ", " + counts[2].LocationName : "") // body of the SMS message

                                    }, function(err, responseData) { //this function is executed when a response is received from Twilio

                                        if (!err) { // "err" is an error received during the request, if any

                                            // "responseData" is a JavaScript object containing data received from Twilio.
                                            // A sample response from sending an SMS message is here (click "JSON" to see how the data appears in JavaScript):
                                            // http://www.twilio.com/docs/api/rest/sending-sms#example-1

                                            console.log(responseData.from); // outputs "+14506667788"
                                            console.log(responseData.body); // outputs "word to your mother."
                                            
                                            res.status(200).send();
                                            
                                            return;

                                        }
                                });
                                
                                return;
                                
                            }
                            
                        }
                        
                    });
                    
                }
                
            });
                    
                }
                
            });
                
        } catch (exception) {
            
            //console.log(exception);

            client.sendMessage({

                to: sms, // Any number Twilio can deliver to
                from: req.body.To, // A number you bought from Twilio and can use for outbound communication
                body: 'Hi There! We could not understand your request. Please send a text with what your looking for and the location. Example: Bars, Santa Monica' // body of the SMS message

                }, function(err, responseData) { //this function is executed when a response is received from Twilio

                    if (!err) { // "err" is an error received during the request, if any

                        // "responseData" is a JavaScript object containing data received from Twilio.
                        // A sample response from sending an SMS message is here (click "JSON" to see how the data appears in JavaScript):
                        // http://www.twilio.com/docs/api/rest/sending-sms#example-1

                        console.log(responseData.from); // outputs "+14506667788"
                        console.log(responseData.body); // outputs "word to your mother."
                        //console.log(exception);
                        
                        res.status(200).send();
                        
                        return;

                    }
            });

        }
        
    } catch(exception) {
        
        res.status(500).send("Something went wrong");
        
    }
    
});

module.exports = router;