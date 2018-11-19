//
//  Venue.swift
//  MerlinFourSquare
//
//  Created by Gonzalinho on 11/16/18.
//  Copyright © 2018 Gonzalinho. All rights reserved.
//

import Foundation

class Venue: Decodable {
    let hasPerk: Bool?
    let id: String
    let categories: [Categories]
    let name: String
    let location: FourSquareLocation
    let referralId: String?
    let venuePage: String?
    
    init?(dictionary: JSONObject) {
        guard
            let identifier = dictionary[Parameters.identifier] as? String,
            let name = dictionary[Parameters.name] as? String,
            let categoriesJSON = dictionary[Parameters.categories] as? [JSONObject],
            let firstCategoryJSON = categoriesJSON.first,
            let categories = Categories(dictionary: firstCategoryJSON),
            let locationJSON = dictionary[Parameters.location] as? JSONObject,
            let location = FourSquareLocation(dictionary: locationJSON)
        else {
            return nil
        }
        id = identifier
        self.name = name
        self.categories = [categories]
        self.location = location
        hasPerk = nil
        referralId = nil
        venuePage = nil
    }
    
    private enum Parameters {
        static let identifier = "id"
        static let name = "name"
        static let categories = "categories"
        static let location = "location"
    }
}

