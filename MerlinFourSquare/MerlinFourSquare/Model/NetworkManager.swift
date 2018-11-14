//
//  NetworkManager.swift
//  MerlinFourSquare
//
//  Created by Gonzalinho on 11/14/18.
//  Copyright © 2018 Gonzalinho. All rights reserved.
//

import Foundation

class NetworkManager {
    static func performStandartRequest() {
        
        guard
            let url = URL(string: "https://api.foursquare.com/v2/venues/search")
        else {
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard
                let data = data
            else {
                print("Service Error")
                DispatchQueue.main.async(execute: {
                    print("Completion closure")
                })
                return
            }
            
            guard let 
            
        }
        
        task.resume()
    }
}
