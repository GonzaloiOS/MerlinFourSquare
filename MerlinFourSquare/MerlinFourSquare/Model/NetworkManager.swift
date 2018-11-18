//
//  NetworkManager.swift
//  MerlinFourSquare
//
//  Created by Gonzalinho on 11/14/18.
//  Copyright © 2018 Gonzalinho. All rights reserved.
//

import Foundation

typealias NetworkJSONObjectCompletionClosure = (_ responseDictionary: JSONObject?, _ error: Error?) -> Void
typealias NetworkDataCompletionClosure = (_ data: Data?,_ error: Error?) -> Void
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
                //let urlString = "https://api.foursquare.com/v2/venues/search?ll=4.592000,-74.158767&client_id=IJEWNYNTYDJ4SUU00FO0CTSW50IDXWPG2MIZLBPG5WEL4TXQ&client_secret=SX0RDDTIAF1RZXBFVITY0SK2M0XZUMKDNYR5MDDPILT5BGGN&v=20181116&intent=checkin"
        
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
    
    private static func createURLString(endpoint: String, parameters: JSONObject) -> String {
        var finalURLString = FourSquareServer.production + endpoint
        
        for (key, value) in parameters {
            finalURLString += "&\(key)=\(value)"
        }
        
        return finalURLString
    }
}

