//
//  GCMClient.swift
//  Surplus
//
//  Created by Daniel Lee on 2/25/16.
//  Copyright © 2016 Daniel Lee. All rights reserved.
//

import Foundation

class GCMClient {
    static let sendUrl = "https://android.googleapis.com/gcm/send"
    static let subscriptionTopic = "/topics/global"
    static let apiKey = "AIzaSyCSomLjShjLpDKW_Yqm4lhCDA36HkkCYEM"
    
    class func sendMessage(to: String) {
        // Create the request.
        let request = NSMutableURLRequest(URL: NSURL(string: sendUrl)!)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(apiKey)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 60
        
        // prepare the payload
        let message = getMessage(to)
        let jsonBody: NSData?
        do {
            jsonBody = try NSJSONSerialization.dataWithJSONObject(message, options: [])
            request.HTTPBody = jsonBody!
            
            NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                if error != nil {
                    print("Error in async message request: \(error)")
                } else {
                    print("Success! Response from the GCM server:")
                    print(response)
                }
            })
        } catch let error as NSError {
            print("Error in sending message: \(error)")
        }
    }
    
    class func getMessage(to: String) -> NSDictionary {
        // [START notification_format]
        return ["to": to, "notification": ["body": "Hello from \(FBUserInfo.name)"]]
        // [END notification_format]
    }
    
//    class func getApiKey() -> String {
//        return apiKeyTextField.stringValue.stringByReplacingOccurrencesOfString("\n", withString: "")
//    }
//    
//    class func getRegToken() -> String {
//        return regIdTextField.stringValue.stringByReplacingOccurrencesOfString("\n", withString: "")
//    }
}