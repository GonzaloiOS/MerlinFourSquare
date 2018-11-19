//
//  FourSquareIcon.swift
//  MerlinFourSquare
//
//  Created by Gonzalinho on 11/19/18.
//  Copyright © 2018 Gonzalinho. All rights reserved.
//

import Foundation

class Icon: Decodable {
    let prefix: String
    let suffix: String
    
    init?(dictionary: JSONObject) {
        guard
            let sufix = dictionary[Parameters.sufix] as? String,
            let prefix = dictionary[Parameters.prefix] as? String
        else {
            return nil
        }
        
        self.suffix = sufix
        self.prefix = prefix
    }
    
    private enum Parameters {
        static let sufix = "suffix"
        static let prefix = "prefix"
    }
    
}
