//
//  Venue.swift
//  MerlinFourSquare
//
//  Created by Gonzalinho on 11/16/18.
//  Copyright © 2018 Gonzalinho. All rights reserved.
//

import Foundation

struct FourSquareResponse: Decodable {
    let meta: FourSquareMeta
    let response: FourSquareDataResponse
}

struct FourSquareMeta: Decodable {
    let requestId: String
    let code: Int
    let errorType: String?
    let errorDetail: String?
}

struct FourSquareDataResponse: Decodable {
    let confident: Bool
    let venues: [Venue]
}


struct Venue: Decodable {
    let hasPerk: Bool
    let id: String
    let categories: [Categories]
    let name: String
    let location: FourSquareLocation
    let referralId: String
}


struct Categories: Decodable {
    let id: String
    let pluralName: String
    let icon: Icon
    let name: String
    let shortName: String
    let primary: Bool
}


struct Icon: Decodable {
    let prefix: String
    let suffix: String
}

struct FourSquareLocation: Decodable {
    let crossStreet: String?
    let address: String?
    let state: String?
    let city: String?
    let distance: Int
    let postalCode: String?
    let country: String
    let formattedAddress: [String]
    let lat: Double
    let lng: Double
    let labeledLatLngs: [LabeledLatLngs]
    let cc: String
    
}

struct LabeledLatLngs: Decodable {
    let label: String
    let lat: Double
    let lng: Double
}
