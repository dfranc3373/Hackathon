//
//  APIExtention.swift
//  Sense360StarterSwift
//
//  Created by Derrick Franco on 8/8/15.
//  Copyright (c) 2015 Sense360. All rights reserved.
//

import Foundation

class APIExtension {
    
    var crowdSourceData: Bool
    
    init(shouldAppCrowdSource: Bool) {
        
        crowdSourceData = shouldAppCrowdSource;
        
    }
    
    func crowdSource(latitude:Double, longitude:Double, type:String, arriving:Bool = false) {
        
        if(crowdSourceData) {
        
            let urlPath: String = "192.168.7.244:3000/SetUserLocation";
            var url: NSURL = NSURL(string: urlPath)!
            var request1: NSMutableURLRequest = NSMutableURLRequest(URL: url)
            
            var timestamp: Double
            
            timestamp = NSDate().timeIntervalSince1970
        
            request1.HTTPMethod = "POST"
            var stringPost="latitude=\(latitude)&longitude=\(longitude)&type=\(type)&WhenTheyArrived=\((arriving ? timestamp : 0))&WhenTheyLeft=\((!arriving ? timestamp : 0))" // Key and Value
        
            let data = stringPost.dataUsingEncoding(NSUTF8StringEncoding)
        
            request1.timeoutInterval = 60
            request1.HTTPBody=data
            request1.HTTPShouldHandleCookies=false
        
            let queue:NSOperationQueue = NSOperationQueue()
        
            NSURLConnection.sendAsynchronousRequest(request1, queue: queue, completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                var err: NSError
                
                if(response != nil) {
                
                    var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
                    println("AsSynchronous\(jsonResult)")
                    
                }
            })
            
        }
        
    }

}