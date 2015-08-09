var express = require('express');
var router = express.Router();
var mongoose = require('mongoose');
var Users = require('../models/User.js');
var request = require('request');

mongoose.connect("mongodb://localhost/sense360");

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});

router.post('/SetUserLocation', function(req, res) {
    
    if(req.body.UDID) {
        
        var type;
        
        if(req.body.type == "Resturant") {
            
            type = "food";
            
        }
        
        request({ uri: "https://maps.googleapis.com/maps/api/place/radarsearch/json?location=" + req.body.latitude + "," + longitude + "&radius=500&types=" + food + "&key=AIzaSyDCzqI9TzdvhIxLXRxH2SfZODNXlVVuyZw", method: 'GET'}, function(err, response, bodydata) {
              
            console.log(bodydata);
            
            if(err) {
                
                res.status(500).send(JSON.stringify({ Error: err }));
                
            } else {
                
                var locations = JSON.parse(bodydata);
                
                if(locations.results.count != 0) {
                    
                    var id = locations.results[0].place_id;
                    
                    request({ uri: "https://maps.googleapis.com/maps/api/place/details/json?placeid=" + id + "&key=AIzaSyDCzqI9TzdvhIxLXRxH2SfZODNXlVVuyZw", method: 'GET'}, function(err, response, bodydata) {
              
                        console.log(bodydata);

                        if(err) {

                            res.status(500).send(JSON.stringify({ Error: err }));

                        } else {

                            var location = JSON.parse(bodydata);

                            if(location.name != "") {
                                
                                Users.findOne({ 'UDID': req.body.UDID }, function(err, user) {
            
                                            if(err) {

                                                res.status(500).send(JSON.stringify({ Success: false, Error: err }));

                                            } else {

                                                if(user.count == 0) {

                                                     var user = new User({ LocationID: id, LocationName: location.name, TypeOfLocation: type, WhenTheyArrived: (req.body.WhenTheyArrived != 0 ? req.body.WhenTheyArrived : 0), WhenTheyLeft: (req.body.WhenTheyLeft != 0 ? req.body.WhenTheyLeft: 0) });

                                                    user.save(function(err, u) {

                                                        if(err) {

                                                            res.status(500).send(JSON.stringify({ Success: false, Error: err }));

                                                        } else {

                                                            res.status(200).send(JSON.stringify({ Success: true }));

                                                        }

                                                    });

                                                } else {//their is a user that exist

                                                    User.update({ 'UDID': req.body.UDID }, { LocationID: id, LocationName: location.name, TypeOfLocation: type, WhenTheyArried: (req.body.WhenTheyArrived != "" ? req.body.WhenTheyArrived : ""), WhenTheyLeft: (req.body.WhenTheyLeft != "" ? req.body.WhenTheyLeft: "") }, function(err, u) {

                                                        if(err) {

                                                            res.status(500).send(JSON.stringify({ Success: false, Error: err }));

                                                        } else {

                                                            res.status(200).send(JSON.stringify({ Success: true }));

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

                    res.status(500).send(JSON.stringify({ Error: err }));

                }

            }

        });

    } else {

        res.status(500).send(JSON.stringify({ Error: err }));

    }
   
});
            
router.post('/GetNumberOfUsersAtLocation', function(req, res) {
    
    if(req.body.LocationID) {
        
        Users.find({ 'LocationID': req.body.LocationID, WhenTheyLeft: 0 }, function(err, users) {
            
            if(err) {
                
                res.status(500).send(JSON.stringify({ Success: false, Error: err }));
                
            } else {
                
                res.status(200).send(JSON.stringify({ UserCount: users.count, Success: true }));
                
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

    if(documents.length == 0) {
        
        callback(false, LocationArray);
        
    }
    
    var Location = Locations.shift();
    
    Users.find({ "LocationID": Location, WhenTheyLeft: 0 }, function(err, users) {
        
        if(err) {
            
            callback(true);
            
        } else {
            
            LocationArray.push({ Location: Location, Count: users.count });
            
            if(Locations.count == 0) {
            
                callback(false, LocationArray);//it worked send the locations and count back
                
            } else {
                
                getUserCount(Locations, LocationArray, callback);
                
            }
            
        }
        
    });
    
}

router.post('/GetNumberOfUsersAtAllLocations', function(req, res) {
    
    var locationCount = [];
    
    User.find().distinct("LocationID", function(err, locations) {

        getUserCount(location, locationCount, function(err, counts) {
            
            if(err) {
                
                res.status(500).send();
                
            } else {
                
            res.status(200).send(JSON.stringify(counts));
                
            }

        });
        
    });
        
});

module.exports = router;