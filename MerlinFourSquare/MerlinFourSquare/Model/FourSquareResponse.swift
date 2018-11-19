//
//  FourSquareResponse.swift
//  MerlinFourSquare
//
//  Created by Gonzalinho on 11/19/18.
//  Copyright © 2018 Gonzalinho. All rights reserved.
//

import Foundation

class FourSquareResponse: Decodable {
    let meta: FourSquareMeta
    let response: FourSquareDataResponse
    
    init?(dictionary: JSONObject) {
        guard
            let metaJSON = dictionary["meta"] as? JSONObject,
            let meta = FourSquareMeta(dictionary: metaJSON),
            let responseJSON = dictionary["response"] as? JSONObject,
            let response = FourSquareDataResponse(dictionary: responseJSON)
            else {
                return nil
        }
        
        self.meta = meta
        self.response = response
    }
}

class FourSquareDataResponse: Decodable {
    let confident: Bool?
    let venues: [Venue]
    
    init?(dictionary: JSONObject) {
        guard let venuesJSON = dictionary["venues"] as? [JSONObject] else { return nil }
        
        var currentVenues = [Venue]()
        
        for venueJSON in venuesJSON {
            guard let itemVenue = Venue(dictionary: venueJSON) else { continue }
            currentVenues.append(itemVenue)
        }
        
        venues = currentVenues
        confident = dictionary["confident"] as? Bool
    }
}
