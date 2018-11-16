//
//  NetworkManager.swift
//  MerlinFourSquare
//
//  Created by Gonzalinho on 11/14/18.
//  Copyright © 2018 Gonzalinho. All rights reserved.
//

import Foundation

typealias NetworkCompletionClosure = (_ responseDictionary: JSONObject?, _ error: Error?) -> Void
typealias JSONObject = [String: Any]

private enum FourSquareServer {
    static let production = "https://api.foursquare.com/v2/"
    static let development = ""
}

private enum RequestParameters {
    static let timeOutInterval = TimeInterval(60)
}

enum FourSquareEndPoint {
    static let searchVenues = "venues/search?"
}

enum FourSquareKeys {
    static let client_id = "IJEWNYNTYDJ4SUU00FO0CTSW50IDXWPG2MIZLBPG5WEL4TXQ"
    static let client_secret = "SX0RDDTIAF1RZXBFVITY0SK2M0XZUMKDNYR5MDDPILT5BGGN"
}


class NetworkManager {
    static func performStandartRequest(endpoint: String, parameters: JSONObject, completion: @escaping NetworkCompletionClosure) {
        
        var finalURLString = FourSquareServer.production + endpoint
        
        for (key, value) in parameters {
            finalURLString += "&\(key)=\(value)"
        }
        
        
        //let urlString = "https://api.foursquare.com/v2/venues/search?ll=4.592000,-74.158767&client_id=IJEWNYNTYDJ4SUU00FO0CTSW50IDXWPG2MIZLBPG5WEL4TXQ&client_secret=SX0RDDTIAF1RZXBFVITY0SK2M0XZUMKDNYR5MDDPILT5BGGN&v=20181116&intent=checkin"
        
        guard
            let url = URL(string: finalURLString)
        else {
            return
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
            
            guard
                let dataDictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSONObject
            else {
                DispatchQueue.main.async(execute: {
                    completion(nil, error)
                })
                return
            }

            print(dataDictionary)
            print(dataDictionary?.prettyPrint())
            
            DispatchQueue.main.async(execute: {
                completion(dataDictionary, error)
            })
            
            
            /*
             if let
             dataDictionary = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? JSONObject,
             let responseDictionary = dataDictionary?[APIResponseKey.response] as? JSONObject {
             performOnMainThread({
             completion(responseDictionary,nil)
             })
             } else {
             performOnMainThread({
             completion(nil, NSError(error: TockAllCityError.unknown))
             })
             */
            
        }
        
        task.resume()
    }
}

extension Dictionary where Key == String, Value == Any {
    func prettyPrint() -> String{
        var string: String = ""
        if let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted){
            if let nstr = NSString(data: data, encoding: String.Encoding.utf8.rawValue){
                string = nstr as String
            }
        }
        return string
    }
}


struct FourSquareResponse: Decodable {
    let meta: FourSquareMeta
    let response: FourSquareDataResponse
}

struct FourSquareMeta: Decodable {
    let requestID: String
    let code: Int
}

struct FourSquareDataResponse: Decodable {
    let confident: Bool
    let venues: [Venues]
}
