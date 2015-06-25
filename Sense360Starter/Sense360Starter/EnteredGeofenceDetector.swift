//
//  EnteredGeofenceDetector.swift
//  Sense360Starter
//
//  Created by Sense360 on 6/22/15.
//  Copyright (c) 2015 Sense360. All rights reserved.
//

import UIKit
import SenseSdk

class EnteredGeofenceDetector: RecipeFiredDelegate {
    
    func geofenceDetectionStart() {
        let errorPointer = SenseSdkErrorPointer.create()
        
        // Create two geofences
        let hq = CustomGeofence(latitude: 37.124, longitude: -127.456, radius: 50, customIdentifier: "Sense 360 Headquarters")
        let lunchSpot = CustomGeofence(latitude: 37.124, longitude: -127.456, radius: 50, customIdentifier: "A&B Bar and Grill")
        
        // Fire on both hq and lunchSpot
        let trigger: Trigger? = FireTrigger.whenEntersGeofences([hq, lunchSpot])
        
        if let geofenceTrigger = trigger {
            // Recipe defines what trigger, what time of day and how long to wait between consecutive firings
            let geofenceRecipe = Recipe(name: "ArrivedAtGeofence",
                trigger: geofenceTrigger,
                // Do NOT restrict the firing to a particular time of day
                timeWindow: TimeWindow.allDay,
                // Wait at least 1 hour between consecutive triggers firing.
                cooldown: Cooldown.create(oncePer: 1, frequency: CooldownTimeUnit.Hours)!)
            
            // register the unique recipe and specify that when the trigger fires it should call our own "onTriggerFired" method below
            SenseSdk.register(recipe: geofenceRecipe, delegate: self)
        }
    }
    
    
    @objc func recipeFired(args: RecipeFiredArgs) {
        
        // Your user has entered a geofence!
        
        NSLog("Recipe \(args.recipe.name) fired at \(args.timestamp).");
        for trigger in args.triggersFired {
            for place in trigger.places {
                NSLog(place.description)
                let transitionDesc = args.recipe.trigger.transitionType.description
                NotificationSender.send("\(transitionDesc) \(place.description)")
            }
        }
    }
}
