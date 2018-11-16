//
//  FourSquareAPI.swift
//  MerlinFourSquare
//
//  Created by Gonzalinho on 11/16/18.
//  Copyright © 2018 Gonzalinho. All rights reserved.
//

import Foundation
import CoreLocation

typealias FourSquareAPICompletionClosure = (_ response: [Venues]?, _ error: Error?) -> Void

class FourSquareAPI {
    func fetchNearbyVenues(location: CLLocation, completion: @escaping FourSquareAPICompletionClosure) {
        let parameters = fetchVenuesParameters(location: location, dateString: "20181110")
        
        NetworkManager.performStandartRequest(endpoint: FourSquareEndPoint.searchVenues, parameters: parameters) { (responseDictionary, error) in
            
        }
    }
    
    private func fetchVenuesParameters(location: CLLocation, dateString: String) -> JSONObject {
        var parameters = JSONObject()
        parameters[Key.Parameters.location] = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
        parameters[Key.Parameters.clientIdentifier] = FourSquareKeys.client_id
        parameters[Key.Parameters.clientSecret] = FourSquareKeys.client_secret
        parameters[Key.Parameters.date] = dateString
        parameters[Key.Parameters.intent] = "checkin"
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
