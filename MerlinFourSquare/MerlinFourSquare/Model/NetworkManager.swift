//
//  NetworkManager.swift
//  MerlinFourSquare
//
//  Created by Gonzalinho on 11/14/18.
//  Copyright © 2018 Gonzalinho. All rights reserved.
//

import Foundation
import UIKit

typealias NetworkJSONObjectCompletionClosure = (_ responseDictionary: JSONObject?, _ error: Error?) -> Void
typealias NetworkDataCompletionClosure = (_ data: Data?,_ error: Error?) -> Void
typealias NetworkDownloadImageCompletionClosure = (_ image: UIImage?) -> Void

typealias JSONObject = [String: Any]

private enum FourSquareServer {
    static let production = "https://api.foursquare.com/v2/"
    static let development = ""
}

private enum RequestParameters {
    static let timeOutInterval = TimeInterval(60)
}

class NetworkManager {
    static func performJSONObjectStandartRequest(endpoint: String, parameters: JSONObject, completion: @escaping NetworkJSONObjectCompletionClosure) {
        let finalURLString = createURLString(endpoint: endpoint, parameters: parameters)
        
        guard
            let url = URL(string: finalURLString)
        else {
            return
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = RequestParameters.timeOutInterval
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard
                let data = data,
                let dataDictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSONObject
            else {
                DispatchQueue.main.async(execute: {
                    completion(nil, error)
                })
                return
            }
            
            DispatchQueue.main.async(execute: {
                completion(dataDictionary, error)
            })
        }
        
        task.resume()
    }
    
    //For future develop, if dont use it please remove"
    static func performDataStandartRequest(endpoint: String, parameters: JSONObject, completion: @escaping NetworkDataCompletionClosure) {
        let finalURLString = createURLString(endpoint: endpoint, parameters: parameters)
        
        guard
            let url = URL(string: finalURLString)
        else {
            return //Handle this please
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = RequestParameters.timeOutInterval
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard
                let data = data
            else {
                DispatchQueue.main.async(execute: {
                    completion(nil, error)
                })
                return
            }
            
            DispatchQueue.main.async(execute: {
                completion(data, error)
            })
        }
        
        task.resume()
    }
    
    static func downloadImageFromURL(url: URL, completion: @escaping NetworkDownloadImageCompletionClosure) {
        let task = URLSession.shared.dataTask(with: url) { (responseData, response, error) in
            guard
                let data = responseData
            else {
                DispatchQueue.main.async(execute: {
                    completion(nil)
                })
                return
            }
            
            let image = UIImage(data: data)
            
            DispatchQueue.main.async(execute: {
                completion(image)
            })
        }
        
        task.resume()
    }
    
    private static func createURLString(endpoint: String, parameters: JSONObject) -> String {
        var finalURLString = FourSquareServer.production + endpoint
        
        for (key, value) in parameters {
            finalURLString += "&\(key)=\(value)"
        }
        
        return finalURLString
    }
}

