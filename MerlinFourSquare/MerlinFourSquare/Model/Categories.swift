//
//  Categories.swift
//  MerlinFourSquare
//
//  Created by Gonzalinho on 11/19/18.
//  Copyright © 2018 Gonzalinho. All rights reserved.
//

import Foundation

class Categories: Decodable {
    let id: String
    let pluralName: String
    let icon: Icon
    let name: String
    let shortName: String
    let primary: Bool?
    
    init?(dictionary: JSONObject) {
        guard
            let identifier = dictionary[Parameters.identifier] as? String,
            let name = dictionary[Parameters.name] as? String,
            let pluralName = dictionary[Parameters.pluralName] as? String,
            let iconJSON = dictionary[Parameters.icon] as? JSONObject,
            let iconObject = Icon(dictionary: iconJSON),
            let shortName = dictionary[Parameters.shortName] as? String
            else {
                return nil
        }
        
        id = identifier
        self.pluralName = pluralName
        self.name = name
        self.shortName = shortName
        self.icon = iconObject
        primary = nil
    }
    
    private enum Parameters {
        static let identifier = "id"
        static let name = "name"
        static let pluralName = "pluralName"
        static let location = "location"
        static let icon = "icon"
        static let shortName = "shortName"
    }
}
