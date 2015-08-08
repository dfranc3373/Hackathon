var mongoose = require('mongoose');
var Schema = mongoose.Schema;
 
module.exports = mongoose.model('User',{
    
    UDID: String,
    LocationID: String,
	LocationName: String,
    TypeOfLocation: String,
    WhenTheyArrived: Date,
    WhenTheyLeft: Date
    
});