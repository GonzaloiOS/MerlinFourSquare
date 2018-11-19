//
//  FourSquareAPI.swift
//  MerlinFourSquare
//
//  Created by Gonzalinho on 11/16/18.
//  Copyright © 2018 Gonzalinho. All rights reserved.
//

import Foundation
import CoreLocation

typealias FourSquareAPICompletionClosure = (_ response: [Venue]?, _ error: Error?) -> Void

struct FourSquareAPIConfig {
    static let foursquareDateStringFormat = "yyyyMMdd"
}

enum FourSquareRequestCodes {
    static let successCode = 200
}

enum FourSquareMerlinError: Error {
    case services
    case internet
    case decodable
}

class FourSquareAPI {
    func fetchNearbyVenues(location: CLLocation, completion: @escaping FourSquareAPICompletionClosure) {
        
        let dateString = currentDate()
        
        let parameters = fetchVenuesParameters(location: location, dateString: dateString)//Improve this
        
        NetworkManager.performJSONObjectStandartRequest(endpoint: FourSquareEndPoint.searchVenues, parameters: parameters) { (responseDictionary, error) in
            guard
                let dictionary = responseDictionary,
                let fourSquareResponse = FourSquareResponse(dictionary: dictionary)
            else {
                completion(nil, FourSquareMerlinError.services)
                return
            }
            
            if self.isErrorRequest(meta: fourSquareResponse.meta) {
                completion(nil, FourSquareMerlinError.services)
            } else {
                completion(fourSquareResponse.response.venues, nil)
            }
        }
    }
    
    func isErrorRequest(meta: FourSquareMeta) -> Bool {
        let isSuccess = meta.code != FourSquareRequestCodes.successCode
        return isSuccess
    }
    
    private func currentDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = FourSquareAPIConfig.foursquareDateStringFormat
        return dateFormatter.string(from: date)
    }
    
    private func fetchVenuesParameters(location: CLLocation, dateString: String) -> JSONObject {
        var parameters = JSONObject()
        parameters[Key.Parameters.location] = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
        parameters[Key.Parameters.clientIdentifier] = FourSquareKeys.clientIdentifier
        parameters[Key.Parameters.clientSecret] = FourSquareKeys.clientSecret
        parameters[Key.Parameters.date] = dateString
        parameters[Key.Parameters.intent] = FourSquareEndPoint.intentCheckin
        return parameters
    }
    
    private enum Key {
        enum Parameters {
            static let location = "ll"
            static let clientIdentifier = "client_id"
            static let clientSecret = "client_secret"
            static let intent = "intent"
            static let date = "v"
        }
    }
}
