//
//  VenueCollectionViewCell.swift
//  MerlinFourSquare
//
//  Created by Gonzalinho on 11/18/18.
//  Copyright © 2018 Gonzalinho. All rights reserved.
//

import UIKit

struct VenueCollectionViewCellConfig {
    static let metters = " m"
    static let nameLabelFontSize = CGFloat(14)
    static let detailFontSize = CGFloat(13)
    static let distanceFontSize = CGFloat(12)
}


class VenueCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupInterface()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.layer.cornerRadius = iconImageView.bounds.height / 2
        
    }
    
    private func setupInterface() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        
        setupImageView()
        setupNameLabel()
        setupDetailLabel()
        setupDistanceLabel()
    }
    
    private func setupImageView() {
        iconImageView.backgroundColor = UIColor.blue.withAlphaComponent(0.1)
        iconImageView.clipsToBounds = true
        iconImageView.layer.borderColor = UIColor(red:0.21, green:0.64, blue:0.79, alpha:1.0).cgColor
        iconImageView.layer.borderWidth = 2
    }
    
    private func setupNameLabel() {
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: VenueCollectionViewCellConfig.nameLabelFontSize, weight: .regular)
        nameLabel.numberOfLines = 2
    }
    
    private func setupDetailLabel() {
        detailLabel.textAlignment = .center
        detailLabel.font = UIFont.systemFont(ofSize: VenueCollectionViewCellConfig.detailFontSize, weight: .light)
    }
    
    private func setupDistanceLabel() {
        distanceLabel.textAlignment = .center
        distanceLabel.font = UIFont.systemFont(ofSize: VenueCollectionViewCellConfig.distanceFontSize, weight: .light)
    }

    func setupCell(venue: Venue) {
        nameLabel.text = venue.name
        detailLabel.text = venue.categories.first?.shortName
        distanceLabel.text = String(venue.location.distance) + VenueCollectionViewCellConfig.metters
    }
}
