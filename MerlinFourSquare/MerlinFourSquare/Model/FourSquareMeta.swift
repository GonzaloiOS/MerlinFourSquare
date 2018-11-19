//
//  FourSquareMeta.swift
//  MerlinFourSquare
//
//  Created by Gonzalinho on 11/19/18.
//  Copyright © 2018 Gonzalinho. All rights reserved.
//

import Foundation

class FourSquareMeta: Decodable {
    let requestId: String
    let code: Int
    let errorType: String?
    let errorDetail: String?
    
    init?(dictionary: JSONObject) {
        guard
            let requestIdentifier = dictionary["requestId"] as? String,
            let code = dictionary["code"] as? Int
        else {
            return nil
        }
        
        requestId = requestIdentifier
        self.code = code
        
        errorType = nil
        errorDetail = nil
    }
}
