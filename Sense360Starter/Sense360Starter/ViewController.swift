//
//  ViewController.swift
//  Sense360Starter
//
//  Created by Sense360 on 6/22/15.
//  Copyright (c) 2015 Sense360. All rights reserved.
//

import UIKit
import SenseSdk

class ViewController: UIViewController {

    @IBOutlet weak var restaurantButton: UIButton!
    
    @IBOutlet weak var homeButton: UIButton!
    
    @IBOutlet weak var geofenceButton: UIButton!
    
    var manager: OneShotLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        manager = OneShotLocationManager()
        manager!.fetchWithCompletion {location, error in
            
            // fetch location or an error
            if let loc = location {
                println(location)
            } else if let err = error {
                println(err.localizedDescription)
            }
            
            self.manager = nil
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func triggerRestaurant(sender: UIButton) {
        // Test info
        let place = PoiPlace(latitude: 34.111, longitude: -118.111, radius: 50, name: "Big Restaurant", id: "id1", types: [.Restaurant])
        
        let errorPointer = SenseSdkErrorPointer.create()
        // This method should only be used for testing
        SenseSdkTestUtility.fireTrigger(
            fromRecipe: "ArrivedAtRestaurant",
            confidenceLevel: ConfidenceLevel.Medium,
            places: [place],
            errorPtr: errorPointer
        )
        
        if errorPointer.error != nil {
            NSLog("Error sending trigger")
        }
    }
    @IBAction func triggerHome(sender: UIButton) {
        
        // Test info
        
        let place = PersonalizedPlace(latitude: 34.111, longitude: -118.111, radius: 50, personalizedPlaceType: .Home)
        
        let errorPointer = SenseSdkErrorPointer.create()
        // This method should only be used for testing
        SenseSdkTestUtility.fireTrigger(
            fromRecipe: "ArrivedAtHome",
            confidenceLevel: ConfidenceLevel.Medium,
            places: [place],
            errorPtr: errorPointer
        )
        
        if errorPointer.error != nil {
            NSLog("Error sending trigger")
        }
    }

    @IBAction func triggerGeofence(sender: UIButton) {
        
        // Create two geofences
        let hq = CustomGeofence(latitude: 37.124, longitude: -127.456, radius: 50, customIdentifier: "Sense 360 Headquarters")
        let lunchSpot = CustomGeofence(latitude: 37.124, longitude: -127.456, radius: 50, customIdentifier: "A&B Bar and Grill")
        
        let errorPointer = SenseSdkErrorPointer.create()
        if errorPointer.error != nil {
            NSLog("Error!: \(errorPointer.error.message)")
        }
        
        
        // This method should only be used for testing
        SenseSdkTestUtility.fireTrigger(
            fromRecipe: "ArrivedAtGeofence",
            confidenceLevel: ConfidenceLevel.Medium,
            places: [hq, lunchSpot],
            errorPtr: errorPointer
        )
        
        if errorPointer.error != nil {
            NSLog("Error sending trigger")
        }
        
    }
}

