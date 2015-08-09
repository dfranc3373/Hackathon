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

    @IBOutlet weak var restaurantArrive: UIButton!
    
    @IBOutlet weak var restaurantDepart: UIButton!
    
    @IBOutlet weak var barArrive: UIButton!
    
    @IBOutlet weak var barDepart: UIButton!
    
    @IBOutlet weak var gymArrive: UIButton!
    
    @IBOutlet weak var gymDepart: UIButton!
    
    @IBOutlet weak var airportArrive: UIButton!
    
    @IBOutlet weak var airportDepart: UIButton!
    
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

    @IBAction func triggerEnterRestaurant(sender: UIButton) {
        // Test info
        let place = PoiPlace(latitude: 33.9982588, longitude: -118.477932834, radius: 50, name: "La Cabana", id: "id1", types: [.Restaurant])
        
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
    
    @IBAction func triggerLeaveRestaurant(sender: UIButton) {
        // Test info
        let place = PoiPlace(latitude: 33.9982588, longitude: -118.477932834, radius: 50, name: "La Cabana", id: "id1", types: [.Restaurant])
        
        let errorPointer = SenseSdkErrorPointer.create()
        // This method should only be used for testing
        SenseSdkTestUtility.fireTrigger(
            fromRecipe: "LeftRestaurant",
            confidenceLevel: ConfidenceLevel.Medium,
            places: [place],
            errorPtr: errorPointer
        )
        
        if errorPointer.error != nil {
            NSLog("Error sending trigger")
        }
    }

    
    @IBAction func triggerEnterAirport(sender: UIButton) {
        // Test info
        let place = PoiPlace(latitude: 34.0175514, longitude: -118.4474779, radius: 50, name: "Santa Monica Airport", id: "id1", types: [.Restaurant])
        
        let errorPointer = SenseSdkErrorPointer.create()
        // This method should only be used for testing
        SenseSdkTestUtility.fireTrigger(
            fromRecipe: "ArrivedAtAirport",
            confidenceLevel: ConfidenceLevel.Medium,
            places: [place],
            errorPtr: errorPointer
        )
        
        if errorPointer.error != nil {
            NSLog("Error sending trigger")
        }
    }
    
    @IBAction func triggerLeaveAirport(sender: UIButton) {
        // Test info
        let place = PoiPlace(latitude: 34.0175514, longitude: -118.4474779, radius: 50, name: "Santa Monica Airport", id: "id1", types: [.Restaurant])
        
        let errorPointer = SenseSdkErrorPointer.create()
        // This method should only be used for testing
        SenseSdkTestUtility.fireTrigger(
            fromRecipe: "LeftAirport",
            confidenceLevel: ConfidenceLevel.Medium,
            places: [place],
            errorPtr: errorPointer
        )
        
        if errorPointer.error != nil {
            NSLog("Error sending trigger")
        }
    }
    
    
    @IBAction func triggerEnterBar(sender: UIButton) {
        // Test info
        let place = PoiPlace(latitude: 34.0218198, longitude: -118.4392382, radius: 50, name: "Gabes", id: "id1", types: [.Restaurant])
        
        let errorPointer = SenseSdkErrorPointer.create()
        // This method should only be used for testing
        SenseSdkTestUtility.fireTrigger(
            fromRecipe: "ArrivedAtBar",
            confidenceLevel: ConfidenceLevel.Medium,
            places: [place],
            errorPtr: errorPointer
        )
        
        if errorPointer.error != nil {
            NSLog("Error sending trigger")
        }
    }
    
    @IBAction func triggerLeaveBar(sender: UIButton) {
        // Test info
        let place = PoiPlace(latitude: 34.0218198, longitude: -118.4392382, radius: 50, name: "Gabes", id: "id1", types: [.Restaurant])
        
        let errorPointer = SenseSdkErrorPointer.create()
        // This method should only be used for testing
        SenseSdkTestUtility.fireTrigger(
            fromRecipe: "LeftBar",
            confidenceLevel: ConfidenceLevel.Medium,
            places: [place],
            errorPtr: errorPointer
        )
        
        if errorPointer.error != nil {
            NSLog("Error sending trigger")
        }
    }
    
    
    @IBAction func triggerEnterGym(sender: UIButton) {
        // Test info
        let place = PoiPlace(latitude: 34.0187608, longitude: -118.424604, radius: 50, name: "Gym", id: "id1", types: [.Restaurant])
        
        let errorPointer = SenseSdkErrorPointer.create()
        // This method should only be used for testing
        SenseSdkTestUtility.fireTrigger(
            fromRecipe: "ArrivedAtGym",
            confidenceLevel: ConfidenceLevel.Medium,
            places: [place],
            errorPtr: errorPointer
        )
        
        if errorPointer.error != nil {
            NSLog("Error sending trigger")
        }
    }
    
    @IBAction func triggerLeaveGym(sender: UIButton) {
        // Test info
        let place = PoiPlace(latitude: 34.0187608, longitude: -118.424604, radius: 50, name: "Gym", id: "id1", types: [.Restaurant])
        
        let errorPointer = SenseSdkErrorPointer.create()
        // This method should only be used for testing
        SenseSdkTestUtility.fireTrigger(
            fromRecipe: "LeftGym",
            confidenceLevel: ConfidenceLevel.Medium,
            places: [place],
            errorPtr: errorPointer
        )
        
        if errorPointer.error != nil {
            NSLog("Error sending trigger")
        }
    }
    
}

