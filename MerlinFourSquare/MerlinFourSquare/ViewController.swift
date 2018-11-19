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
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func venuesTapped() {
        guard let venueListController = storyboard?.instantiateViewController(withIdentifier: "VenueListViewController") as? VenueListViewController else { return }
        
        present(venueListController, animated: true, completion: nil)
    }
    
    
    @IBAction func mapTapped() {
        print("WIP")
        
    }
    
}

