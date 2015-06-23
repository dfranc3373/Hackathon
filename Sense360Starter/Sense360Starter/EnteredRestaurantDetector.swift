//
//  EnteredRestaurantDetector.swift
//  Sense360Starter
//
//  Created by Sense360 on 6/22/15.
//  Copyright (c) 2015 Sense360. All rights reserved.
//

import UIKit
import SenseSdk

class EnteredRestaurantDetector: RecipeFiredDelegate {

    func restaurantDetectionStart() {
        let errorPointer = SenseSdkErrorPointer.create()
        // Fire when the user enters a restaurant
        let trigger = FireTrigger.whenEntersPoi(.Restaurant, errorPtr: errorPointer)
        
        if let restaurantTrigger = trigger {
            // Recipe defines what trigger, what time of day and how long to wait between consecutive firings
            let restaurantRecipe = Recipe(name: "ArrivedAtRestaurant",
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
                NSLog(place.description)
            }
        }
    }
}