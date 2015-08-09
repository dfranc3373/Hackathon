var mongoose = require('mongoose');
var Schema = mongoose.Schema;
 
module.exports = mongoose.model('User',{
    
    UDID: { index: true, type: String },
    LocationID: { index: true, type: String },
	LocationName: String,
    TypeOfLocation: { index: true, type: String },
    WhenTheyArrived: Date,
    WhenTheyLeft: Date
    
});