//
//  AppDelegate.swift
//  Sense360Starter
//
//  Created by Sense360 on 6/22/15.
//  Copyright (c) 2015 Sense360. All rights reserved.
//

import UIKit
import SenseSdk

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, RecipeFiredDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Replace with your app key provided by Sense360
        SenseSdk.enableSdkWithKey("app_key_goes_here")
        
        // Create the Restaurant POI Type
        EnteredRestaurantDetector().restaurantDetectionStart()
        
        // Create the Home Personal Place Type
        EnteredHomeDetector().homeDetectionStart()
        
        // Create a custom geofence
        EnteredGeofenceDetector().geofenceDetectionStart()
        
        
        //...Any other code that should run on launch...//
        
        return true
    }
    
    func recipeFired(args: RecipeFiredArgs) {
        
        NSLog("Recipe \(args.recipe.name) fired at \(args.timestamp). ")
        
        if args.triggersFired.count > 0 {
            let triggerFired = args.triggersFired[0]
            if triggerFired.places.count > 0 {
                let place = triggerFired.places[0]
                
                let transitionDesc = args.recipe.trigger.transitionType.description
                switch(place.type) {
                case .CustomGeofence:
                    if let geofence = place as? CustomGeofence {
                        NotificationSender.send("\(transitionDesc) \(geofence.customIdentifier)")
                    }
                    break;
                case .Personal:
                    if let personal = place as? PersonalizedPlace {
                        NotificationSender.send("\(transitionDesc) \(personal.personalizedPlaceType.description)")
                    }
                    break;
                case .Poi:
                    if let poi = place as? PoiPlace {
                        NotificationSender.send("\(transitionDesc) \(poi.types[0].description)")
                    }
                    break;
                }
            }
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

