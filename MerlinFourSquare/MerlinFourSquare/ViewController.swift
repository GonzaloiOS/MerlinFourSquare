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
    @IBOutlet weak var venueListButton: UIButton!
    @IBOutlet weak var mapButtton: UIButton!
    
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
        presentNextController(controller: venueListController)
    }
    
    
    @IBAction func mapTapped() {
        let controllerName = String(describing: MapVenuesViewController.self)
        guard let mapVenueController = storyboard?.instantiateViewController(withIdentifier: controllerName) as? MapVenuesViewController else { return }
        presentNextController(controller: mapVenueController)
    }
    
    private func presentNextController(controller: UIViewController) {
        navigationController?.pushViewController(controller, animated: true)
    }
}

