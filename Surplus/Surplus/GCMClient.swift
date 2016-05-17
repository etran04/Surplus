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
    
    class func sendNotification(token: String, body: String) {
        print("Got here for surplus!")
        let postURL: String = "https://gcm-http.googleapis.com/gcm/send"
        let reqURL = NSURL(string: postURL)
        let request = NSMutableURLRequest(URL: reqURL!)
        request.HTTPMethod = "POST"
        request.setValue("key=AIzaSyCSomLjShjLpDKW_Yqm4lhCDA36HkkCYEM", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let params = ["to": token, "content-available": "1", "notification":["title":"Surplu$", "body": body, "sound": "default", "badge":"1"]]
        
        do {
            let jsonPost = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
            request.HTTPBody = jsonPost
            
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithRequest(request, completionHandler: {
                (data, response, error) in
                
                guard data != nil else {
                    print("Error: did not receive data")
                    return
                }
                guard error == nil else {
                    print("error calling POST on /event/create")
                    print(error)
                    return
                }
                print("Response: \(response)")
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Body: \(strData)")
                print("successful post!")
            })
            task.resume()
        } catch {
            print("Error: cannot create JSON from event")
        }
    }
    
    /**
     * Attempts to send a message to another user with either a topic, registration token, or group.
     */
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
        
        print("about to send message")
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
    
    /**
     * Sends a message to another user using a registration token.
     */
    class func sendMessageWithToken(token: String) {
        self.sendMessage(token)
    }
    
    /**
     * Prepares the message payload.
     */
    class func getMessage(to: String) -> NSDictionary {
        return ["to": to, "notification": ["body": "\(FBUserInfo.name) has claimed your order!", "title": "Surplu$"]]
    }
    
//    class func getApiKey() -> String {
//        return apiKeyTextField.stringValue.stringByReplacingOccurrencesOfString("\n", withString: "")
//    }
//    
//    class func getRegToken() -> String {
//        return regIdTextField.stringValue.stringByReplacingOccurrencesOfString("\n", withString: "")
//    }
}