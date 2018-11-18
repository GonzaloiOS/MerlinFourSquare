//
//  Dictionary+Extension.swift
//  MerlinFourSquare
//
//  Created by Gonzalinho on 11/18/18.
//  Copyright © 2018 Gonzalinho. All rights reserved.
//

import Foundation

extension Dictionary where Key == String, Value == Any {
    func prettyPrint() -> String{
        var string: String = ""
        if let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted){
            if let nstr = NSString(data: data, encoding: String.Encoding.utf8.rawValue){
                string = nstr as String
            }
        }
        return string
    }
}
