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

enum FourSquareRequestCodes {
    static let successCode = 200
}

class FourSquareAPI {
    func fetchNearbyVenues(location: CLLocation, completion: @escaping FourSquareAPICompletionClosure) {
        let parameters = fetchVenuesParameters(location: location, dateString: "20181110")//Improve this
        
        NetworkManager.performDataStandartRequest(endpoint: FourSquareEndPoint.searchVenues, parameters: parameters) { (responseData, error) in
            guard
                let data = responseData,
                let fourSquareResponse = try? JSONDecoder().decode(FourSquareResponse.self, from: data)
            else {
                completion(nil, error)//Hanlde error please
                return
            }
            
            if self.isErrorRequest(meta: fourSquareResponse.meta) {
                completion(nil, error) //Error from foursquare API
            } else {
                completion(fourSquareResponse.response.venues, nil)
            }
        }
    }
    
    func isErrorRequest(meta: FourSquareMeta) -> Bool {
        let isSuccess = meta.code != FourSquareRequestCodes.successCode
        return isSuccess
    }
    
    func processMetaResponse(meta: FourSquareMeta) {
        
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
        //"https://api.foursquare.com/v2/venues/search?ll=4.592000,-74.158767&client_id=IJEWNYNTYDJ4SUU00FO0CTSW50IDXWPG2MIZLBPG5WEL4TXQ&client_secret=SX0RDDTIAF1RZXBFVITY0SK2M0XZUMKDNYR5MDDPILT5BGGN&v=20181116&intent=checkin"
        
        enum Parameters {
            static let location = "ll"
            static let clientIdentifier = "client_id"
            static let clientSecret = "client_secret"
            static let intent = "intent"
            static let date = "v"
        }
    }
}
