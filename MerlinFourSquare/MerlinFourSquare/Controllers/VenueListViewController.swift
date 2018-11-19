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
}

class VenueListViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    var collectionViewData = [Venue]()
    var cachedImage = [String: UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        setupData()
    }
    
    private func setupData() {
        let location = CLLocation(latitude: 4.591965, longitude: -74.158788)
        
        activityIndicator.startAnimating()
        FourSquareAPI().fetchNearbyVenues(location: location) { (venues, error) in
            self.activityIndicator.stopAnimating()
            guard
                let currentVenues = venues
            else {
                print("Error Venues")
                return
            }
            
            self.collectionViewData = currentVenues
            self.collectionView.reloadData()
        }
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
        layout.itemSize = CGSize(width: ((UIScreen.main.bounds.width - 60) / 2), height: 180)//Config
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)//Config
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        return layout
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
