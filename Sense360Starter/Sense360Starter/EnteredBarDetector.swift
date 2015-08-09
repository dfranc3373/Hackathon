//
//  EnteredRestaurantDetector.swift
//  Sense360Starter
//
//  Created by Sense360 on 6/22/15.
//  Copyright (c) 2015 Sense360. All rights reserved.
//

import UIKit
import SenseSdk
import GoogleMaps

class EnteredBarDetector: RecipeFiredDelegate {
    
    //var locationManager: CLLocationManager = CLLocationManager()
    
    var placesClient: GMSPlacesClient?
    
    let api = APIExtension(shouldAppCrowdSource: true);
    
    func barDetectionStart() {
        
        //locationManager.requestWhenInUseAuthorization()
        //locationManager.requestAlwaysAuthorization()
        
        let errorPointer = SenseSdkErrorPointer.create()
        // Fire when the user enters a restaurant
        let trigger = FireTrigger.whenEntersPoi(.Restaurant, errorPtr: errorPointer)
        
        if let restaurantTrigger = trigger {
            // Recipe defines what trigger, what time of day and how long to wait between consecutive firings
            let restaurantRecipe = Recipe(name: "ArrivedAtBar",
                trigger: restaurantTrigger,
                // Do NOT restrict the firing to a particular time of day
                timeWindow: TimeWindow.allDay,
                // Wait at least 1 hour between consecutive triggers firing.
                cooldown: Cooldown.create(oncePer: 1, frequency: CooldownTimeUnit.Hours)!)
            
            // register the unique recipe and specify that when the trigger fires it should call our own "onTriggerFired" method below
            SenseSdk.register(recipe: restaurantRecipe, delegate: self)
        }
        
        let triggerExited = FireTrigger.whenEntersPoi(.Restaurant, errorPtr: errorPointer)
        
        if let restaurantTrigger = trigger {
            // Recipe defines what trigger, what time of day and how long to wait between consecutive firings
            let restaurantRecipe = Recipe(name: "LeftBar",
                trigger: restaurantTrigger,
                // Do NOT restrict the firing to a particular time of day
                timeWindow: TimeWindow.allDay,
                // Wait at least 1 hour between consecutive triggers firing.
                cooldown: Cooldown.create(oncePer: 1, frequency: CooldownTimeUnit.Hours)!)
            
            // register the unique recipe and specify that when the trigger fires it should call our own "onTriggerFired" method below
            SenseSdk.register(recipe: restaurantRecipe, delegate: self)
        }
        
        if errorPointer.error != nil {
            NSLog("Error!: \(errorPointer.error.message)")
        }
    }
    
    
    @objc func recipeFired(args: RecipeFiredArgs) {
        
        // Your user has entered a restaurant!
        NSLog("Recipe \(args.recipe.name) fired at \(args.timestamp).");
        for trigger in args.triggersFired {
            for place in trigger.places {
                
                NSLog("Latitude: \(place.location.latitude) Longitude \(place.location.longitude)");
                
                if(args.recipe.name == "LeftBar") {
                    
                    api.crowdSource(place.location.latitude, longitude: place.location.longitude, type: "bar", arriving: false)
                    
                } else {
                    
                    api.crowdSource(place.location.latitude, longitude: place.location.longitude, type: "bar", arriving: true)
                    
                }
                
                //This is where YOU write your custom code.
                //As an example, we are sending a local notification that describes the transition type and place.
                //For more information go to: http://sense360.com/docs.html#handling-a-recipe-firing
                let transitionDesc = args.recipe.trigger.transitionType.description
                NotificationSender.send("\(transitionDesc) \(place.description)")
            }
        }
    }
}


