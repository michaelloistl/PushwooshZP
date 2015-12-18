//
//  PushwooshZP.swift
//  PushwooshZP
//
//  Created by Michael Loistl on 18/12/2015.
//  Copyright © 2015 Aplo. All rights reserved.
//

import Foundation
import Alamofire

public protocol PushwooshZPDelegate {
    
}

public class PushwooshZP {
    
    static let APIURLHost = "https://zeropush.pushwoosh.com/"
    static let ClientVersion = "ZeroPush-iOS/2.1.0"
    
    public typealias Completion = (success: Bool, request: NSURLRequest?, response: NSHTTPURLResponse?, responseObject: AnyObject?, error: NSError?) -> Void
    
    var apiKey: String?
    var delegate: PushwooshZPDelegate?
    var deviceToken: String?
    
    public class var sharedInstance: PushwooshZP {
        struct Singleton {
            static let instance = PushwooshZP()
        }
        
        return Singleton.instance
    }
    
    // MARK: - Methods
    
    public class func engageWithAPIKey(apiKey: String) {
        engageWithAPIKey(apiKey, delegate: nil)
    }
    
    public class func engageWithAPIKey(apiKey: String, delegate: PushwooshZPDelegate?) {
        sharedInstance.apiKey = apiKey
        sharedInstance.delegate = delegate
    }
    
    public class func deviceTokenFromData(tokenData: NSData) -> String {
        var token = tokenData.description
        token = token.stringByReplacingOccurrencesOfString("<", withString: "")
        token = token.stringByReplacingOccurrencesOfString(">", withString: "")
        token = token.stringByReplacingOccurrencesOfString(" ", withString: "")
        return token
    }
    
    // MARK: Register
    
    public class func registerForRemoteNotifications() {
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }
    
    public class func registerDeviceToken(deviceToken: NSData) {
        registerDeviceToken(deviceToken, channel: nil) { (success, request, response, responseObject, error) -> Void in
            
        }
    }

    public class func registerDeviceToken(deviceToken: NSData?, channel: String?) {
        registerDeviceToken(deviceToken, channel: channel) { (success, request, response, responseObject, error) -> Void in
            
        }
    }
    
    public class func registerDeviceToken(deviceToken: NSData?, channel: String?, completion: Completion) {
        if let deviceToken = deviceToken {
            sharedInstance.deviceToken = deviceTokenFromData(deviceToken)
        }
        
        if let deviceToken = sharedInstance.deviceToken {
            let path = "register"
            var parameters = ["device_token": deviceToken]
            
            if let channel = channel {
                parameters["channel"] = channel
            }
            
            requestWithMethod(.POST, path: path, parameters: parameters) { (success, request, response, responseObject, error) -> Void in
                
                completion(success: success, request: request, response: response, responseObject: responseObject, error: error)
            }
        } else {
            completion(success: false, request: nil, response: nil, responseObject: nil, error: nil)
        }
    }
    
    public class func unregisterDeviceToken() {
        unregisterDeviceToken { (success, request, response, responseObject, error) -> Void in
            
        }
    }
    
    public class func unregisterDeviceToken(completion: Completion) {
        if let deviceToken = sharedInstance.deviceToken {
            let path = "unregister"
            let parameters = ["device_token": deviceToken]
            
            requestWithMethod(.POST, path: path, parameters: parameters) { (success, request, response, responseObject, error) -> Void in
                
                if success {
                    self.sharedInstance.deviceToken = nil
                }
                
                completion(success: success, request: request, response: response, responseObject: responseObject, error: error)
            }
        } else {
            sharedInstance.deviceToken = nil
            
            completion(success: false, request: nil, response: nil, responseObject: nil, error: nil)
        }
    }
    
    // MARK: Subscribe
    
//    class func subscribeToChannel(channel: String, completion: Completion) {
//        if let deviceToken = sharedInstance.deviceToken {
//            let path = "subscribe"
//            let parameters = ["device_token": deviceToken, "channel": channel]
//            
//            requestWithMethod(.POST, path: path, parameters: parameters) { (success, request, response, responseObject, error) -> Void in
//                
//                completion(success: success, request: request, response: response, responseObject: responseObject, error: error)
//            }
//        } else {
//            completion(success: false, request: nil, response: nil, responseObject: nil, error: nil)
//        }
//    }
//    
//    class func unsubscribeFromChannel(channel: String, completion: Completion) {
//        if let deviceToken = sharedInstance.deviceToken {
//            let path = "subscribe"
//            let parameters = ["device_token": deviceToken, "channel": channel]
//            
//            requestWithMethod(.DELETE, path: path, parameters: parameters) { (success, request, response, responseObject, error) -> Void in
//                
//                completion(success: success, request: request, response: response, responseObject: responseObject, error: error)
//            }
//        } else {
//            completion(success: false, request: nil, response: nil, responseObject: nil, error: nil)
//        }
//    }
//    
//    class func unsubscribeFromAllChannels(completion: Completion) {
//        if let deviceToken = sharedInstance.deviceToken {
//            let path = "devices/\(deviceToken)"
//            let parameters = ["channel_list": ""]
//            
//            requestWithMethod(.PUT, path: path, parameters: parameters) { (success, request, response, responseObject, error) -> Void in
//                
//                completion(success: success, request: request, response: response, responseObject: responseObject, error: error)
//            }
//        } else {
//            completion(success: false, request: nil, response: nil, responseObject: nil, error: nil)
//        }
//    }
//    
//    class func getDevice(completion: Completion) {
//        if let deviceToken = sharedInstance.deviceToken {
//            let path = "devices/\(deviceToken)"
//            
//            requestWithMethod(.GET, path: path, parameters: nil) { (success, request, response, responseObject, error) -> Void in
//                
//                completion(success: success, request: request, response: response, responseObject: responseObject, error: error)
//            }
//        } else {
//            completion(success: false, request: nil, response: nil, responseObject: nil, error: nil)
//        }
//    }
//    
//    class func setChannels(channels: [String], completion: Completion) {
//        if let deviceToken = sharedInstance.deviceToken {
//            let path = "devices/\(deviceToken)"
//            let parameters = ["channel_list": channels.joinWithSeparator(",")]
//            
//            requestWithMethod(.PUT, path: path, parameters: parameters) { (success, request, response, responseObject, error) -> Void in
//                
//                completion(success: success, request: request, response: response, responseObject: responseObject, error: error)
//            }
//        } else {
//            completion(success: false, request: nil, response: nil, responseObject: nil, error: nil)
//        }
//    }
    
    // MARK: Networking
    
    class func requestWithMethod(method: Alamofire.Method, path: String, parameters: [String: AnyObject]?, completion: Completion) {
        
        if let apiKey = sharedInstance.apiKey {
            let urlString = "\(APIURLHost)\(path)"
            let headers = ["Authorization": "Token token=\"\(apiKey)\"", "X-API-Client-Agent": ClientVersion]
            
            Alamofire.request(method, urlString, parameters: parameters, headers: headers).responseJSON { response in
                let isSuccess = response.response?.statusCode >= 200 && response.response?.statusCode < 300
                
                completion(success: isSuccess, request: response.request, response: response.response, responseObject: response.result.value, error: response.result.error)
            }
        } else {
            completion(success: false, request: nil, response: nil, responseObject: nil, error: nil)
        }
    }
}