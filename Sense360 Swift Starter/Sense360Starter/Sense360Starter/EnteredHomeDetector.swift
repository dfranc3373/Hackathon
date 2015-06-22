//
//  EnteredHomeDetector.swift
//  Sense360Starter
//
//  Created by Sense360 on 6/22/15.
//  Copyright (c) 2015 Sense360. All rights reserved.
//

import UIKit
import SenseSdk

class EnteredHomeDetector: RecipeFiredDelegate {
   
    func homeDetectionStart() {
        let errorPointer = SenseSdkErrorPointer.create()
        // Fire when the user enters home
        let trigger = FireTrigger.whenEntersPersonalizedPlace(.Home, errorPtr: errorPointer)
        
        if let homeTrigger = trigger {
            // Recipe defines what trigger, what time of day and how long to wait between consecutive firings
            let homeRecipe = Recipe(name: "ArrivedAtHome",
                trigger: homeTrigger,
                // Do NOT restrict the firing to a particular time of day
                timeWindow: TimeWindow.allDay,
                // Wait at least 1 hour between consecutive triggers firing.
                cooldown: Cooldown.create(oncePer: 1, frequency: CooldownTimeUnit.Hours)!)
            
            // register the unique recipe and specify that when the trigger fires it should call our own "onTriggerFired" method below
            SenseSdk.register(recipe: homeRecipe, delegate: self)
        }
        
        if errorPointer.error != nil {
            NSLog("Error!: \(errorPointer.error.message)")
        }

    }
    
    @objc func recipeFired(args: RecipeFiredArgs) {
        
        // Your user has entered at home!
        
        NSLog("Recipe \(args.recipe.name) fired at \(args.timestamp).");
        for trigger in args.triggersFired {
            for place in trigger.places {
                NSLog(place.description)
            }
        }
    }
}