//
//  VenueCollectionViewCell.swift
//  MerlinFourSquare
//
//  Created by Gonzalinho on 11/18/18.
//  Copyright © 2018 Gonzalinho. All rights reserved.
//

import UIKit

class VenueCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupInterface()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.layer.cornerRadius = iconImageView.bounds.height / 2
        
    }
    
    private func setupInterface() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        iconImageView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        iconImageView.clipsToBounds = true
        iconImageView.layer.borderColor = UIColor(red:0.21, green:0.64, blue:0.79, alpha:1.0).cgColor//Config
        iconImageView.layer.borderWidth = 2
        
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        nameLabel.numberOfLines = 2
        
        
        detailLabel.textAlignment = .center
        detailLabel.font = UIFont.systemFont(ofSize: 13, weight: .light)
        
        distanceLabel.textAlignment = .center
        distanceLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
    }

    func setupCell(venue: Venue) {
        nameLabel.text = venue.name
        detailLabel.text = venue.categories.first?.shortName
        distanceLabel.text = String(venue.location.distance) + "m"
    }
}
