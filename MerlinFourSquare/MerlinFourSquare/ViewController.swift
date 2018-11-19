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
        setupInterface()
    }
    
    private func setupInterface() {
        navigationItem.title = "Welcome"
    }

    @IBAction func venuesTapped() {
        let controllerName = String(describing: VenueListViewController.self)
        guard let venueListController = storyboard?.instantiateViewController(withIdentifier: controllerName) as? VenueListViewController else { return }
        navigationController?.pushViewController(venueListController, animated: true)
    }
    
    
    @IBAction func mapTapped() {
        print("WIP")
        
    }
}

