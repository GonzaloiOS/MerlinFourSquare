//
//  FourSquareLocation.swift
//  MerlinFourSquare
//
//  Created by Gonzalinho on 11/19/18.
//  Copyright © 2018 Gonzalinho. All rights reserved.
//

import Foundation

class FourSquareLocation: Decodable {
    let neighborhood: String?
    let crossStreet: String?
    let address: String?
    let state: String?
    let city: String?
    let distance: Int
    let postalCode: String?
    let country: String?
    let formattedAddress: [String]?
    let lat: Double
    let lng: Double
    let labeledLatLngs: [LabeledLatLngs]?
    let cc: String?
    
    init?(dictionary: JSONObject) {
        guard
            let latitude = dictionary[Parameters.latitude] as? Double,
            let longitude = dictionary[Parameters.longitude] as? Double,
            let distance = dictionary[Parameters.distance] as? Int
            else {
                return nil
        }
        
        lat = latitude
        lng = longitude
        self.distance = distance
        
        neighborhood = nil
        crossStreet = nil
        address = nil
        state = nil
        city = nil
        postalCode = nil
        country = nil
        formattedAddress = nil
        labeledLatLngs = nil
        cc = nil
    }
    
    private enum Parameters {
        static let latitude = "lat"
        static let longitude = "lng"
        static let distance = "distance"
    }
    
}

class LabeledLatLngs: Decodable {
    let label: String
    let lat: Double
    let lng: Double
}
