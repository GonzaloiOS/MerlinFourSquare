//
//  VenueListViewController.swift
//  MerlinFourSquare
//
//  Created by Gonzalinho on 11/18/18.
//  Copyright © 2018 Gonzalinho. All rights reserved.
//

import UIKit
import CoreLocation

struct VenueListViewControllerConfig {
    static let imageSize64 = "64"
    static let venuesText = "Venues"
    static let accpetButtonText = "Ok"
    static let errorText = "Error"
    static let errorMessage = "Try again please"
    static let actionLocation = "Activate location services and then deload"
    static let collectionViewCellHeight = CGFloat(180)
    static let sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
}

class VenueListViewController: UIViewController {
    var collectionViewData = [Venue]()
    var cachedImage = [String: UIImage]()
    var currentLocation: CLLocation?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .other
        return locationManager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        setupLocationManager()
    }
    
    private func setupData() {
        guard let location = currentLocation else { return }
        
        activityIndicator.startAnimating()
        FourSquareAPI().fetchNearbyVenues(location: location) { (venues, error) in
            self.activityIndicator.stopAnimating()
            guard
                let currentVenues = venues
            else {
                self.presentAlertError()
                return
            }
            
            self.collectionViewData = currentVenues
            self.collectionView.reloadData()
        }
    }
    
    private func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func setupInterface() {
        view.backgroundColor = UIColor.white
        navigationItem.title = VenueListViewControllerConfig.venuesText
        setupCollectionView()
        setupActivityIndicator()
    }
    
    private func setupCollectionView() {
        let nib = UINib(nibName: VenueCollectionViewCell.defaultReuseIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: VenueCollectionViewCell.defaultReuseIdentifier)
        collectionView.backgroundColor = UIColor.clear
        collectionView.collectionViewLayout = createflowLayout()
        collectionView.dataSource = self
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
    }
    
    private func createflowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: ((UIScreen.main.bounds.width - 60) / 2), height: VenueListViewControllerConfig.collectionViewCellHeight)
        layout.sectionInset = VenueListViewControllerConfig.sectionInset
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        return layout
    }
    
    private func presentAlertError() {
        let okAction = UIAlertAction(title: VenueListViewControllerConfig.accpetButtonText, style: .default) { (alerAction) in
            self.backToPreviousController()
        }
        
        presentAlertController(title: VenueListViewControllerConfig.errorText, message: VenueListViewControllerConfig.errorMessage, actions: [okAction])
    }
    
    private func backToPreviousController() {
        navigationController?.popViewController(animated: true)
    }
    
    private func presentLocationPermissionAlert() {
        let okAction = UIAlertAction(title: VenueListViewControllerConfig.accpetButtonText, style: .default) { (alertAction) in
            self.backPreviousController()
        }
        
        presentAlertController(title: VenueListViewControllerConfig.errorText,
                               message: VenueListViewControllerConfig.actionLocation,
                               actions: [okAction])
    }
    
    
    private func backPreviousController() {
        navigationController?.popViewController(animated: true)
    }
}

extension VenueListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: VenueCollectionViewCell.defaultReuseIdentifier, for: indexPath)
        
        guard let cell = collectionViewCell as? VenueCollectionViewCell else { return collectionViewCell }
        let item = collectionViewData[indexPath.row]
        cell.setupCell(venue: item)
        
        guard let iconCharacteristics = item.categories.first?.icon else { return cell }
        
        let imageURL = iconCharacteristics.prefix + VenueListViewControllerConfig.imageSize64 + iconCharacteristics.suffix
        
        if let cachedImage = cachedImage[imageURL] {
            cell.iconImageView.image = cachedImage
        } else {
            cell.tag = indexPath.row
            guard let url = URL(string: imageURL) else { return cell }
            NetworkManager.downloadImageFromURL(url: url) { (image) in
                self.cachedImage[imageURL] = image
                
                if cell.tag == indexPath.row {
                    cell.iconImageView.image = image
                }
            }
        }
        
        return cell
    }
}

extension VenueListViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        if currentLocation == nil {
            currentLocation = location
            setupData()
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            presentLocationPermissionAlert()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        }
    }
    
    
}
