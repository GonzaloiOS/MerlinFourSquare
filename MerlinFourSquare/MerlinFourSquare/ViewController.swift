//
//  ViewController.swift
//  MerlinFourSquare
//
//  Created by Gonzalinho on 11/14/18.
//  Copyright © 2018 Gonzalinho. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let location = CLLocation(latitude: 4.591965, longitude: -74.158788)
        FourSquareAPI().fetchNearbyVenues(location: location) { (venues, error) in
            
            guard
                let currentVenues = venues
            else {
                print("Error Venues")
                return
            }
            
            print(currentVenues)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }


}

